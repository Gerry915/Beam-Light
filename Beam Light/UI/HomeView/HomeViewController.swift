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
	
    // MARK: - Properties

    var viewModel: BookshelvesViewModel
	
	lazy var dataSource = createDataSource()
	lazy var emptyView = EmptyBookshelfCreationView { [weak self] in
		self?.handleCreateBookshelf()
	}
	
	var subscription = Set<AnyCancellable>()
    
    var analyticsService: AnalyticsEngine = FakeAnalyticsEngine()
    
    // MARK: - Init
    init(viewModel: BookshelvesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
    
    // MARK: - View Lifecycle
	
	override func loadView() {
		super.loadView()
		super.setupCollectionView()
		view.alpha = 0
		view.transform = .init(translationX: 0, y: -50)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		analyticsService.log(event: HomeViewEvent.screenView)
        setup()
		setupObserver()
		collectionViewConfiguration()
        addTapToResignFirstResponder()
        
		Task {
			await viewModel.getAllBookshelf()
			view.animate(inParallel: [
				.fadeIn(duration: 0.25),
				.transformIdentity(duration: 0.35)
			])
		}

		binding()
    }
	
	private func addEmptyView() {
		collectionView.addSubview(emptyView)
		
		NSLayoutConstraint.activate([
			emptyView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
			emptyView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
		])
	}
	
	private func removeEmptyView() {
		emptyView.removeFromSuperview()
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
		viewModel.$bookshelves.receive(on: DispatchQueue.main).sink { [weak self] items in
			guard let self = self else { return }
			self.applySnapshot()
			if items.count == 0 {
				self.addEmptyView()
			} else {
				self.removeEmptyView()
			}
			
		}.store(in: &subscription)
	}
	
	private func setupObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleDataChange), name: .updatedBookshelves, object: nil)
	}
	
	@objc
	private func handleDataChange() {
		print("trigger")
		Task {
			await viewModel.getAllBookshelf()
		}
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
		cell.viewModel = BookshelfViewModel(updateBookshelfUseCase: Resolver.shared.resolve(UpdateBookshelfUseCaseProtocol.self), bookshelf: bookshelf)
        
        return cell
    }
    
    private func handlePresentBookshelfDetailViewController(bookshelf: Bookshelf) {

        let bookshelfViewModel = BookshelfViewModel(updateBookshelfUseCase: Resolver.shared.resolve(UpdateBookshelfUseCaseProtocol.self), bookshelf: bookshelf)
        
        let VC = BookshelfDetailViewController(style: .plain,
                                               viewModel: bookshelfViewModel)
        
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
    private func handlePresentBookDetailView(book: Book) {
        let viewModel = BookViewModel(book: book, loader: DiskStorageService.shared)
        let VC = BookDetailViewController(bookViewModel: viewModel, displayToolBar: false)
        VC.title = viewModel.title

        let navVC = UINavigationController(rootViewController: VC)
        navVC.modalPresentationStyle = .pageSheet

        navigationController?.present(navVC, animated: true)
    }
    
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		guard let searchQuery = searchBar.text else { return }
        		
        let searchResultViewController = SearchResultViewController(
			viewModel: BooksViewModel(service: iTunesAPIProvider(), terms: searchQuery)
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
