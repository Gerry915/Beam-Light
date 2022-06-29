//
//  BookshelvesViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit
import Combine

class BookshelvesViewController: UITableViewController {
	
	typealias DataSource = UITableViewDiffableDataSource<Sections, Bookshelf>
	typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, Bookshelf>
    
    // MARK: - Properties
	
	lazy var dataSource = createDataSource()
    
    var footerView: BookshelfFooter!
    var viewModel: BookshelvesViewModel
	
	var subscription = Set<AnyCancellable>()
    
//    lazy var loadingView: UIActivityIndicatorView = LoadingView(style: .medium)
    lazy var deleteButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(didPressDelete))
    
    // MARK: - Init
    
    init(viewModel: BookshelvesViewModel) {
        self.viewModel = viewModel
        
        super.init(style: .insetGrouped)
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
		
        setupView()
        setupObserver()
		
		fadeOut()
		
		Task {
			await viewModel.getAllBookshelf()
			fadeIn()
		}
		binding()
    }
    
    // MARK: - Methods
	
	private func binding() {
		viewModel.$bookshelves.receive(on: DispatchQueue.main).sink { [weak self] items in
			print(items.count)
			self?.applySnapshot(animated: true)
			
		}.store(in: &subscription)
	}
	
	private func createDataSource() -> DataSource {
		
		let dataSource = DataSource(tableView: tableView) { [unowned self] tableView, indexPath, itemIdentifier in
			
			let cell = tableView.dequeueReusableCell(withIdentifier: BookshelfCell.reusableIdentifier, for: indexPath) as! BookshelfCell
			
			let presentable = viewModel.getBookshelf(for: indexPath.row)
			cell.selectionStyle = .none
			cell.configure(title: presentable.title, bookCount: presentable.books.count)
			
			return cell
		}
		
		dataSource.defaultRowAnimation = .fade
		
		return dataSource
		
	}
	
	private func applySnapshot(animated: Bool) {
		var snapshot = Snapshot()
		
		snapshot.appendSections([.Bookshelf])
		
		snapshot.appendItems(viewModel.bookshelves, toSection: .Bookshelf)
		
		dataSource.apply(snapshot, animatingDifferences: animated)
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
    
    private func postNotificationForBookshelfUpdate() {
        NotificationCenter.default.post(name: .updatedBookshelves, object: nil)
    }
    
    private func setupView() {
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItems = [editButtonItem]
		
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.delegate = self
        
        tableView.register(BookshelfCell.self, forCellReuseIdentifier: BookshelfCell.reusableIdentifier)
        tableView.register(BookshelfFooter.self, forHeaderFooterViewReuseIdentifier: BookshelfFooter.reusableIdentifier)
    }
    
    @objc private func didPressDelete() {
        //        Problem is: tableView.indexPathForSelectedRows is gonna
        //        save the rows you have selected in the order you tapped them.
        //        So if you tap the items to delete from top to bottom, you will
        //        eventually get an index out of range error.
        //        Add selectedRows = selectedRows?.sorted(by: >)to fix the issue.
        
        guard let selectedRows = tableView.indexPathsForSelectedRows else { return }
		
		let ids = selectedRows.map({ $0.row })
		
		Task {
			await viewModel.batchDelete(ids: ids)
		}
		
		postNotificationForBookshelfUpdate()
		
//        selectedRows.sort(by: >)
//
//        viewModel.deleteMultiItem(for: selectedRows) { [weak self] success in
//            guard let self = self else { return }
//            if success {
//                DispatchQueue.main.async {
//                    self.deleteButtonItem.isEnabled = false
//                    self.tableView.deleteRows(at: selectedRows, with: .fade)
//                    self.postNotificationForBookshelfUpdate()
//                }
//            }
//        }
    }
}

extension BookshelvesViewController {
    
    // MARK: - TableView
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            navigationItem.rightBarButtonItems = [editButtonItem, deleteButtonItem]
            deleteButtonItem.isEnabled = false
        } else {
            navigationItem.rightBarButtonItems = [editButtonItem]
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        footerView = (tableView.dequeueReusableHeaderFooterView(withIdentifier: BookshelfFooter.reusableIdentifier) as! BookshelfFooter)
        
        footerView.handleButtonTap = presentCreateBookshelfViewController
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if tableView.indexPathsForSelectedRows == nil {
                deleteButtonItem.isEnabled = false
            }
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            deleteButtonItem.isEnabled = true
            return
        }
        presentBookshelfDetailViewController(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
			
			guard let self = self else { return }
			
			let bookshelf = self.viewModel.getBookshelf(for: indexPath.row)
			
			Task {
				await self.viewModel.deleteBookshelf(bookshelf.id.uuidString)
				self.postNotificationForBookshelfUpdate()
			}
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        64
    }
    
    private func presentBookshelfDetailViewController(for indexPath: IndexPath) {
        let bookshelf = viewModel.getBookshelf(for: indexPath.row)
        let viewModel = BookshelfViewModel(updateBookshelfUseCase: Resolver.shared.resolve(UpdateBookshelfUseCaseProtocol.self), bookshelf: bookshelf)
        
        let VC = BookshelfDetailViewController(style: .plain, viewModel: viewModel)
        
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
    
    private func presentCreateBookshelfViewController() {
        
        let vc = CreateBookshelfViewController()
        
        vc.didCreateBookshelf = { [unowned self] title in
			Task {
				await viewModel.create(with: title)
				postNotificationForBookshelfUpdate()
			}
        }
        
        navigationController?.present(vc, animated: true)
    }
}
