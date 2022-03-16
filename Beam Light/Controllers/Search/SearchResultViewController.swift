//
//  SearchResultViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    var imageService: ImageCacheable

    var viewModel: SearchResultViewModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    var services: iTunesServiceable?
    
    var searchController: UISearchController!
    var tableView: UITableView!
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

        setupTableView()
        setupView()

        fetchSearchResult()
        
        title = "Results"
    }
    
    private func fetchSearchResult() {
        services = iTunesService()
    
        services?.getSearchResult(terms: searchQuery, completion: { [weak self] (result: Result<Books, NetworkError>) in
            switch result {
            case .success(let result):
                self?.viewModel = SearchResultViewModel(model: result)
            case .failure(let failure):
                // Show alert
                print(failure)
            }
        })
    }
    
    private func setupView() {
        title = "Search Result"
        view.backgroundColor = .systemGray6
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        tableView.backgroundColor = .systemGray6
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reusableIdentifier)
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.resultCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reusableIdentifier, for: indexPath) as! BookTableViewCell
        
        if let presentable = viewModel?.getBookForIndex(index: indexPath.row) {
            
            cell.configure(presentable: presentable, imageService: imageService)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let presentable = viewModel?.getBookForIndex(index: indexPath.row) {

            let bookDetailViewController = BookDetailViewController(book: presentable,
                                              imageService: imageService
                                            )

            navigationController?.pushViewController(bookDetailViewController, animated: true)
        }
    }
}
