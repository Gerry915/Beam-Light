//
//  HomeViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

class HomeViewController: BaseCollectionViewController {
    
    // MARK: - Properties
    lazy var loadingView: LoadingView = LoadingView(style: .medium)
    
    var searchCell: SearchCell?
    var searchQuery: String = ""
    var imageService: ImageCacheable
    var viewModel: BookshelvesViewModel
    
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
    @objc private func updateData() {
        viewModel.loadData { success in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if success {
                    self.collectionView.reloadData()
                    self.loadingView.stopAnimating()
                } else {
                    print("TODO: Add Reload Option for Alert.")
                    self.showAlertView(title: "Error", message: "Cannot Load Data")
                }
            }
        }
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .updatedBookshelves, object: nil)
    }
    
    private func collectionViewConfiguration() {
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(loadingView)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems == 0 ? 1 : viewModel.numberOfItems
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
        print("TODO")
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
                self.updateData()
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
