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
    
    // MARK: - Properties
    
    var searchCell: SearchCell?
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
        
        setup()
		collectionViewConfiguration()
        addTapToResignFirstResponder()
        
		Task {
			await viewModel.getAllBookshelf()
		}

		binding()

    }
    
    // MARK: - Methods
	private func setup() {
		title = "Beam Light"
	}
	
    private func collectionViewConfiguration() {
        collectionView.delegate = self
    }
	
	private func createDataSource() -> DataSource {

		let dataSource = DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, bookshelf in
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookshelfCollectionViewCell.reusableIdentifier, for: indexPath) as! BookshelfCollectionViewCell
			
			cell.showBookDetailViewHandler = { book in
				self.handlePresentBookDetailView(book: book)
			}
			
			cell.showBookshelfDetailHandler = { bookshelf in
				self.handlePresentBookshelfDetailViewController(bookshelf: bookshelf)
			}
			
			cell.titleLabel.text = bookshelf.title
			cell.viewModel = BookshelfViewModel(bookshelf: bookshelf)
			cell.imageService = imageService

			return cell
		}
		
		dataSource.supplementaryViewProvider = {
			collectionView, kind, indexPath in
			guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchCollectionViewHeader.reusableIdentifier, for: indexPath) as? SearchCollectionViewHeader else { return nil }
			
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
		}.store(in: &subscription)
	}
}

extension HomeViewController: UICollectionViewDelegate {
    
    private func generateCell(for indexPath: IndexPath) -> UICollectionViewCell {
        
        return viewModel.isEmpty ? renderEmptyBookshelvesCell(for: indexPath) : renderBookshelfCell(for: indexPath)
    }
    
    private func renderEmptyBookshelvesCell(for indexPath: IndexPath) -> EmptyBookshelvesCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyBookshelvesCell.reusableIdentifier, for: indexPath) as! EmptyBookshelvesCell
        
        cell.handleCreateButtonTap = handleCreateBookshelf
        
        return cell
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
    
    private func handleCreateBookshelf() {
        let VC = CreateBookshelfViewController()
        
        VC.didCreateBookshelf = { [unowned self] title in
            createBookshelf(with: title)
            NotificationCenter.default.post(name: .updatedBookshelves, object: nil)
        }
        navigationController?.present(VC, animated: true)
    }
    
    private func createBookshelf(with title: String) {
        viewModel.save(title: title) { [weak self] success in
            guard let self = self else { return }
            if success {
				Task {
					await self.viewModel.getAllBookshelf()
				}
            }
        }
    }
    
    @objc func resetSearchBarIfNeeded() {
        guard let cell = searchCell else { return }
        if cell.searchBar.isFirstResponder {
            cell.searchBar.resignFirstResponder()
            cell.searchBar.text = ""
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
