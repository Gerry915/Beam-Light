//
//  HomeViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit
import Combine

enum Sections {
	case Bookshelf
}

class HomeViewController: BaseCollectionViewController {
	
	typealias DataSource = UICollectionViewDiffableDataSource<Sections, Bookshelf>
	typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, Bookshelf>
	
	lazy var dataSource = createDataSource()
	
	lazy var emptyView: UIView = {
		
		let view = UIView()
		view.isHidden = true
		
		let label = UILabel()
		
		label.text = "You have no bookshelves"
		label.textColor = .systemGray2
		
		let button = UIButton()
		
		var config = UIButton.Configuration.filled()
		config.cornerStyle = .capsule
		config.contentInsets = .init(top: 8, leading: 24, bottom: 8, trailing: 24)
		
		config.title = "Create"
		
		button.configuration = config
		
		let stackView = UIStackView(arrangedSubviews: [label, button])
		
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .equalCentering
		stackView.spacing = 20
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
		
		button.addTarget(self, action: #selector(handleCreateBookshelf), for: .touchUpInside)
		
		
		return view
	}()
    
    // MARK: - Properties

    var searchQuery: String = ""
    var imageService: ImageCacheable
    var viewModel: BookshelvesViewModel
	
	var subscription = Set<AnyCancellable>()
    
    var analyticsService: AnalyticsEngine = FakeAnalyticsEngine()
    
    // MARK: - Init
    init(imageService: ImageCacheable, viewModel: BookshelvesViewModel) {
        self.viewModel = viewModel
        self.imageService = imageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
	
    override func viewDidLoad() {
		
        super.viewDidLoad()
		super.setupCollectionView()
		
		analyticsService.log(event: HomeViewEvent.screenView)
		
		collectionView.addSubview(emptyView)
		emptyView.translatesAutoresizingMaskIntoConstraints = false
		
		
		NSLayoutConstraint.activate([
			emptyView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
			emptyView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
		])
        
        setup()
		collectionViewConfiguration()
        addTapToResignFirstResponder()
        
		Task {
			await viewModel.getAllBookshelf()
			binding()
		}

    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		Task {
			await viewModel.getAllBookshelf()
		}
	}
    
    // MARK: - Methods
	private func setup() {
		title = "Beam Light"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
    private func collectionViewConfiguration() {
        collectionView.delegate = self
    }
	
	private func createDataSource() -> DataSource {

		let dataSource = DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, bookshelf in
			
			generateCell(for: indexPath)
			
		}
		
		dataSource.supplementaryViewProvider = {
			collectionView, kind, indexPath in
			guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchCollectionViewHeader.reusableIdentifier, for: indexPath) as? SearchCollectionViewHeader else { return nil }
			
			header.searchBar.delegate = self
			
			return header
		}
		
		return dataSource
	}
	
	private func applySnapshot() {
		var snapshot = Snapshot()
		
		snapshot.appendSections([.Bookshelf])
		
		snapshot.appendItems(viewModel.bookshelves, toSection: .Bookshelf)
		
		dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
	}
	
	private func binding() {
		viewModel.$bookshelves.receive(on: DispatchQueue.main).sink { [unowned self] items in
			self.applySnapshot()
			emptyView.isHidden = true
			if items.count == 0 {
				emptyView.isHidden = false
			} else {
				emptyView.isHidden = true
			}
			
		}.store(in: &subscription)
	}
}

extension HomeViewController: UICollectionViewDelegate {
    
    private func generateCell(for indexPath: IndexPath) -> UICollectionViewCell {
		renderBookshelfCell(for: indexPath)
    }

    private func renderBookshelfCell(for indexPath: IndexPath) -> BookshelfCollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookshelfCollectionViewCell.reusableIdentifier, for: indexPath) as! BookshelfCollectionViewCell
        
        cell.showBookDetailViewHandler = { [weak self]  book in
            guard let self = self else { return }
            self.handlePresentBookDetailView(book: book)
        }
        
        cell.showBookshelfDetailHandler = { [weak self] bookshelf in
            guard let self = self else { return }
            
            self.handlePresentBookshelfDetailViewController(bookshelf: bookshelf)
        }
        
        let bookshelf = viewModel.getBookshelf(for: indexPath.row)
        
        cell.titleLabel.text = bookshelf.title
        cell.viewModel = BookshelfViewModel(bookshelf: bookshelf)
        cell.imageService = imageService
        
        return cell
    }
    
    private func handlePresentBookshelfDetailViewController(bookshelf: Bookshelf) {

        let bookshelfViewModel = BookshelfViewModel(bookshelf: bookshelf)
        
        let VC = BookshelfDetailViewController(style: .insetGrouped,
                                               viewModel: bookshelfViewModel,
                                               imageService: imageService)
        
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
    private func handlePresentBookDetailView(book: Book) {
        let viewModel = BookViewModel(book: book, loader: DiskStorageService.shared)
        let VC = BookDetailViewController(bookViewModel: viewModel, imageService: imageService, displayToolBar: false)
        VC.title = viewModel.title

        let navVC = UINavigationController(rootViewController: VC)
        navVC.modalPresentationStyle = .pageSheet

        navigationController?.present(navVC, animated: true)
    }
    
	@objc
    private func handleCreateBookshelf() {
        let VC = CreateBookshelfViewController()
		
		if let sheet = VC.sheetPresentationController {
			sheet.detents = [.medium()]
			sheet.prefersGrabberVisible = false
		}
		
		present(VC, animated: true) {
			VC.didCreateBookshelf = { [unowned self] title in
				Task {
					await viewModel.create(with: title)
				}
			}
		}
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchResultViewController = SearchResultViewController(
            searchQuery: searchQuery,
            imageService: imageService
        )
        
        let navVC = UINavigationController(rootViewController: searchResultViewController)
        searchBar.resignFirstResponder()

        navigationController?.present(navVC, animated: true, completion: nil)
        
        analyticsService.log(event: HomeViewEvent.buttonPressed)
    }
}

extension HomeViewController {
    private enum HomeViewEvent: AnalyticsEvent {
        
        case screenView
        case buttonPressed
        case loginFailed(reason: String)
        
        var name: String {
            switch self {
            case .screenView:
                return "Screen Viewed"
            case .buttonPressed:
                return "Button Pressed"
            case .loginFailed(let reason):
                return reason
            }
        }
        
        var metaData: [String : String] {
            switch self {
            case .screenView:
                return ["View": "1"]
            case .buttonPressed:
                return ["Pressed": "1"]
            case .loginFailed(let reason):
                return ["Reason": reason]
            }
        }
    }
}
