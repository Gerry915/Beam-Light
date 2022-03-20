//
//  HomeViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

class HomeViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    
    var searchCell: SearchCell?
    var searchQuery: String = ""
    var imageService: ImageService
    
    var analyticsService: AnalyticsEngine = FakeAnalyticsEngine()
    
    var viewModel: HomeViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Init
    init(imageService: ImageService) {
        self.imageService = imageService
        super.init(nibName: nil, bundle: nil)
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
        
        super.commonInitWithLayout()
        analyticsService.log(event: HomeViewEvent.screenView)
        
        title = "Beam Light"
        // TODO: - Handle search resign first responder
//        addTapToResignFirstResponder(with: #selector(resetSearchBarIfNeeded))
        addTapToResignFirstResponder()
        
        setupObserver()
        collectionViewConfiguration()
        updateData()
    }
    
    // MARK: - Methods
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .updatedBookshelves, object: nil)
    }
    
    @objc func updateData() {
        DiskStorageService.shared.fetchAll { [weak self] (result: Result<[Bookshelf], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let viewModel = HomeViewModel(bookshelves: data)
                self.viewModel = viewModel
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func collectionViewConfiguration() {
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = generateCell(for: indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionViewHeader.reusableIdentifier, for: indexPath) as! SearchCollectionViewHeader
        
        header.searchBar.delegate = self
        
        return header
    }
    
    private func generateCell(for indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            fatalError("Cannot Dequeue Cell for view")
        }
        
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
        
        if let bookshelf = viewModel?.getBookshelf(for: indexPath.row) {
            cell.titleLabel.text = bookshelf.title
            cell.viewModel = BookshelfDetailViewModel(bookshelf: bookshelf)
            cell.imageService = imageService
        }
        
        return cell
    }
    
    private func handlePresentBookshelfDetailViewController(bookshelf: Bookshelf) {
        
        let bookshelfVM = BookshelfDetailViewModel(bookshelf: bookshelf)
        
        let vc = BookshelfDetailViewController(style: .insetGrouped, viewModel: bookshelfVM, imageService: imageService)
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func handlePresentBookDetailView(book: Book) {
        let bookDetailViewController = BookDetailViewController(book: book, imageService: imageService, displayToolBar: false)
        bookDetailViewController.title = "Book Detail"
        let navVC = UINavigationController(rootViewController: bookDetailViewController)
        navVC.modalPresentationStyle = .pageSheet

        navigationController?.present(navVC, animated: true)
    }
    
    private func handleCreateBookshelf() {
        let vc = CreateBookshelfViewController()
        vc.didCreateBookself = { [unowned self] bookshelf in
            DiskStorageService.shared.save(id: bookshelf.id.uuidString, data: bookshelf) { done in
                if done {
                    self.updateData()
                    vc.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        present(vc, animated: true, completion: nil)
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
