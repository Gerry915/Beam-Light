//
//  SearchResultViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit
import Combine

enum SectionBook {
	case Book
}

class SearchResultViewController: UIViewController {
	
	typealias DataSource = UITableViewDiffableDataSource<SectionBook, Book>
	typealias Snapshot = NSDiffableDataSourceSnapshot<SectionBook, Book>
    
    lazy var loadingView: UIActivityIndicatorView = LoadingView(style: .medium)
	
    var viewModel: BooksViewModel
	
	var subscription = Set<AnyCancellable>()
	
	lazy var tableView: UITableView = {
		
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.delegate = self
		tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reusableIdentifier)
		tableView.backgroundColor = .clear
		
		return tableView
	}()
	
	lazy var dataSource = createDataSource()
    
    // MARK: - Init
    
	init(viewModel: BooksViewModel) {
        
		self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        setupView()
		Task {
			await viewModel.fetch()
			binding()
			loadingView.stopAnimating()
		}
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
		view.addSubview(loadingView)
		loadingView.startAnimating()
    }
	
	private func createDataSource() -> DataSource {
		
		let dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
			
			let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reusableIdentifier, for: indexPath) as! BookTableViewCell
			
			if let presentable = self?.viewModel.generate(for: indexPath.row) {
				cell.configure(presentable: presentable)
			}
			
			return cell
		}
		
		dataSource.defaultRowAnimation = .fade
		
		return dataSource
	}
	
	private func applySnapshot(animated: Bool) {
		
		var snapshot = Snapshot()
		
		snapshot.appendSections([.Book])
		if let books = viewModel.books?.results {
			snapshot.appendItems(books, toSection: .Book)
		}
		
		dataSource.apply(snapshot, animatingDifferences: animated)
	}
	
	private func binding() {
		viewModel.$books.receive(on: DispatchQueue.main).sink { [weak self] _ in
			guard let self = self else { return }
			self.applySnapshot(animated: true)
		}.store(in: &subscription)
	}
	
	
}

extension SearchResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let book = viewModel.generate(for: indexPath.row) {
			let viewModel = BookViewModel(book: book)
			let vc = BookDetailViewController(bookViewModel: viewModel)
			
			show(vc, sender: self)
		}
    }
}
