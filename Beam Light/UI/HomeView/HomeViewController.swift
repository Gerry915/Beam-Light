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

class HomeViewController: UICollectionViewController {
	
	typealias DataSource = UICollectionViewDiffableDataSource<Sections, Bookshelf>
	typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, Bookshelf>
	
    // MARK: - Properties

    var viewModel: BookshelvesViewModel
	
	lazy var dataSource = createDataSource()
	
	var subscription = Set<AnyCancellable>()
	
	var createBookshelf: (() -> Void)?
	var presentBookDetailView: ((Book) -> Void)?
	var presentBookshelf: ((Bookshelf) -> Void)?
	
	lazy var emptyView = EmptyBookshelfCreationView { [weak self] in
		self?.createBookshelf?()
	}
    
    // MARK: - Init
	init(viewModel: BookshelvesViewModel, layout: UICollectionViewLayout) {
        self.viewModel = viewModel
		super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
    
    // MARK: - View Lifecycle
	
    override func viewDidLoad() {
		
        super.viewDidLoad()
		
		setupUI()
		configureCollectionView()
		setupObserver()
        addTapToResignFirstResponder()
		binding()
        
		Task {
			await viewModel.getAllBookshelf()
			fadeIn()

		}
    }
	
	private func setupUI() {
		view.backgroundColor = .systemBackground
		collectionView.backgroundColor = .clear
		fadeOut()
	}
	
	private func configureCollectionView() {
		collectionView.register(EmptyBookshelvesCell.self, forCellWithReuseIdentifier: EmptyBookshelvesCell.reusableIdentifier)
		collectionView.register(BookshelfCollectionViewCell.self, forCellWithReuseIdentifier: BookshelfCollectionViewCell.reusableIdentifier)
		collectionView.register(SearchCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionViewHeader.reusableIdentifier)
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
		viewModel.$bookshelves
			.receive(on: DispatchQueue.main)
			.sink { [weak self] items in
				
			guard let self = self else { return }
			self.applySnapshot()
			items.count == 0 ? self.addEmptyView() : self.removeEmptyView()
		}.store(in: &subscription)
	}
	
	private func setupObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleDataChange), name: .updatedBookshelves, object: nil)
	}
	
	@objc
	private func handleDataChange() {
		Task {
			await viewModel.getAllBookshelf()
		}
	}
}

extension HomeViewController {
    
    private func generateCell(for indexPath: IndexPath) -> UICollectionViewCell {
		renderBookshelfCell(for: indexPath)
    }

    private func renderBookshelfCell(for indexPath: IndexPath) -> BookshelfCollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookshelfCollectionViewCell.reusableIdentifier, for: indexPath) as! BookshelfCollectionViewCell
        
        cell.showBookDetailViewHandler = handlePresentBookDetailView(book:)
        
        cell.showBookshelfDetailHandler = handlePresentBookshelfDetailViewController(bookshelf:)
        
        let bookshelf = viewModel.getBookshelf(for: indexPath.row)
        
        cell.titleLabel.text = bookshelf.title
		cell.viewModel = BookshelfViewModel(updateBookshelfUseCase: Resolver.shared.resolve(UpdateBookshelfUseCaseProtocol.self), bookshelf: bookshelf)
        
        return cell
    }
    
    private func handlePresentBookshelfDetailViewController(bookshelf: Bookshelf) {
		presentBookshelf?(bookshelf)
    }
    
    private func handlePresentBookDetailView(book: Book) {
		presentBookDetailView?(book)
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

		show(navVC, sender: self)
    }
}

