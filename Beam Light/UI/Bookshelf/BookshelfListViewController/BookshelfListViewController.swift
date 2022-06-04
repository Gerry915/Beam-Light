//
//  BookshelfListViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 14/3/2022.
//

import UIKit
import Combine

class BookshelfListViewController: UITableViewController {
	
	typealias DataSource = UITableViewDiffableDataSource<Sections, Bookshelf>
	typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, Bookshelf>
	
	lazy var dataSource = createDataSource()

    var viewModel: BookshelvesViewModel
	
	var subscription = Set<AnyCancellable>()
	
	var bookshelfSelected: ((Int) -> Void)?
    
    init(bookshelvesViewModel: BookshelvesViewModel, style: UITableView.Style = .insetGrouped) {

		self.viewModel = bookshelvesViewModel
        
        super.init(style: style)
        
		setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		Task {
			await viewModel.getAllBookshelf()
			
		}
		binding()
    }
	
	private func createDataSource() -> DataSource {
		
		let dataSource = DataSource(tableView: tableView) { [unowned self] tableView, indexPath, itemIdentifier in
			let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reusableIdentifier, for: indexPath)
			
			let presentable = viewModel.getBookshelf(for: indexPath.row)
			
			// TODO: Update Content method
			cell.textLabel?.text = presentable.title
			
			return cell
		}
		
		dataSource.defaultRowAnimation = .automatic
		
		return dataSource
	}
	
	private func applySnapshot(animated: Bool) {
		var snapshot = Snapshot()
		
		snapshot.appendSections([.Bookshelf])
		snapshot.appendItems(viewModel.bookshelves, toSection: .Bookshelf)
		
		dataSource.apply(snapshot, animatingDifferences: animated)
	}
	
	private func binding() {
		viewModel.$bookshelves.receive(on: DispatchQueue.main).sink { [weak self] _ in
			guard let self = self else { return }
			
			self.applySnapshot(animated: true)
		}.store(in: &subscription)
	}
	
	private func setup() {
		title = "My Bookshelf"
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reusableIdentifier)
	}

}

extension BookshelfListViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		bookshelfSelected?(indexPath.row)
		navigationController?.popViewController(animated: true)
	}
}
