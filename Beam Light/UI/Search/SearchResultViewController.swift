//
//  SearchResultViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    lazy var loadingView: UIActivityIndicatorView = LoadingView(style: .medium)
    
    var imageService: ImageCacheable
	
    var viewModel: BooksViewModel? {
        didSet {
            viewModel?.fetchData(with: searchQuery, completion: { [weak self] success in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.loadingView.stopAnimating()
                }
            })
        }
    }
    
    var searchController: UISearchController!
	
	lazy var tableView: UITableView = {
		
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reusableIdentifier)
		tableView.backgroundColor = .clear
		
		return tableView
	}()
	
    var searchQuery: String
    
    // MARK: - Init
    
    init(searchQuery: String,
         imageService: ImageCacheable
        ) {
        
        self.searchQuery = searchQuery
        self.imageService = imageService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {

        setupView()
        viewModel = BooksViewModel(service: iTunesService())
        
        tableView.addSubview(loadingView)
        loadingView.startAnimating()
		
    }
    
    private func setupView() {
        title = "Search Result"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.resultCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reusableIdentifier, for: indexPath) as! BookTableViewCell
        
        // TODO: ?? Should the viewController knows the book type????
        if let book = viewModel?.getBookForIndex(index: indexPath.row) {
            let viewModel = BookViewModel(book: book, loader: DiskStorageService.shared)
            cell.configure(presentable: viewModel, imageService: imageService)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let book = viewModel?.getBookForIndex(index: indexPath.row) {
            let viewModel = BookViewModel(book: book, loader: DiskStorageService.shared)
            let VC = BookDetailViewController(bookViewModel: viewModel, imageService: imageService)

            navigationController?.pushViewController(VC, animated: true)
        }
    }
}
