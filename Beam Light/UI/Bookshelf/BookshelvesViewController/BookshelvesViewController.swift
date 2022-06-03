//
//  BookshelvesViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

class BookshelvesViewController: UITableViewController {
    
    // MARK: - Properties
    
    var storageService: StorageService?
    var footerView: BookshelfFooter!
    var viewModel: BookshelvesViewModel
    var imageService: ImageService
    
    lazy var loadingView: UIActivityIndicatorView = LoadingView(style: .medium)
    lazy var deleteButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(didPressDelete))
    
    // MARK: - Init
    
    init(imageService: ImageService, viewModel: BookshelvesViewModel) {
        self.imageService = imageService
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
        loadData()
        setupObserver()
        loadingView.startAnimating()
    }
    
    // MARK: - Methods
    
    @objc private func loadData() {
        viewModel.loadData { [weak self] success in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if success {
                    self.tableView.reloadData()
                    self.footerView.isHidden = false
                    self.loadingView.stopAnimating()
                } else {
                    self.showAlertView(title: "Error", message: "Cannot Load Data")
                }
            }
        }
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .updatedBookshelves, object: nil)
    }
    
    private func postNotificationForBookshelfUpdate() {
        NotificationCenter.default.post(name: .updatedBookshelves, object: nil)
    }
    
    private func updateTableViewData(for indexPath: IndexPath) {
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func setupView() {
        
        title = "Bookshelves"
        
        view.backgroundColor = .systemGray6
        
        navigationItem.rightBarButtonItems = [editButtonItem]
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BookshelfCell.self, forCellReuseIdentifier: BookshelfCell.reusableIdentifier)
        tableView.register(BookshelfFooter.self, forHeaderFooterViewReuseIdentifier: BookshelfFooter.reusableIdentifier)
        
        //toolbar setup
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        let deleteButton: UIBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(didPressDelete))
//        self.toolbarItems = [flexible, deleteButton]
        
        // Add loading indicator
        view.addSubview(loadingView)
    }
    
    @objc private func didPressDelete() {
        //        Problem is: tableView.indexPathForSelectedRows is gonna
        //        save the rows you have selected in the order you tapped them.
        //        So if you tap the items to delete from top to bottom, you will
        //        eventually get an index out of range error.
        //        Add selectedRows = selectedRows?.sorted(by: >)to fix the issue.
        
        guard var selectedRows = tableView.indexPathsForSelectedRows else { return }
        selectedRows.sort(by: >)
        
        viewModel.deleteMultiItem(for: selectedRows) { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.deleteButtonItem.isEnabled = false
                    self.tableView.deleteRows(at: selectedRows, with: .fade)
                    self.postNotificationForBookshelfUpdate()
                }
            }
        }
    }
    
    private func updateView() {
        viewModel.loadData { [weak self] success in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if success {
                    self.footerView.isHidden = false
                    self.loadingView.stopAnimating()
                } else {
                    self.showAlertView(title: "Error", message: "Cannot Load Data")
                }
            }
        }
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
            // Save here
            viewModel.saveAll()
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { true }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // TODO: - Change storage data order
        viewModel.saveBookshelfOrder(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        footerView = (tableView.dequeueReusableHeaderFooterView(withIdentifier: BookshelfFooter.reusableIdentifier) as! BookshelfFooter)
        
        if viewModel.isLoading { footerView.isHidden = true }
        
        footerView.handleButtonTap = presentCreateBookshelfViewController
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookshelfCell.reusableIdentifier, for: indexPath) as! BookshelfCell
        
        let model = viewModel.getBookshelf(for: indexPath.row)
        
        cell.configure(title: model.title, bookCount: model.books.count)
        
        return cell
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
            self?.deleteCell(for: indexPath)
            completion(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return config
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        64
    }
    
    private func deleteCell(for indexPath: IndexPath) {
        viewModel.delete(for: indexPath.row) { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.updateTableViewData(for: indexPath)
                }
                self.postNotificationForBookshelfUpdate()
            }
        }
    }
    
    private func presentBookshelfDetailViewController(for indexPath: IndexPath) {
        let bookshelf = viewModel.getBookshelf(for: indexPath.row)
        let viewModel = BookshelfViewModel(bookshelf: bookshelf)
        
        let VC = BookshelfDetailViewController(style: .insetGrouped, viewModel: viewModel, imageService: imageService)
        
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
    
    private func presentCreateBookshelfViewController() {
        
        let vc = CreateBookshelfViewController()
        
        vc.didCreateBookshelf = { [unowned self] title in
            self.createBookshelf(with: title)
        }
        
        navigationController?.present(vc, animated: true)
    }
    
    private func createBookshelf(with title: String) {
        viewModel.save(title: title) { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.performBatchUpdates {
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
                    } completion: { _ in
                        self.postNotificationForBookshelfUpdate()
                    }
                } else {
                    self.showAlertView(title: "Error", message: "Cannot Save Bookshelf")
                }
            }
        }
    }
}
