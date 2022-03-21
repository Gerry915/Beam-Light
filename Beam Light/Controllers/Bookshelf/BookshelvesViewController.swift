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
        
        view.addSubview(loadingView)
        
        setupView()
        updateView()
        setupObserver()
    }
    
    // MARK: - Methods
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: .updatedBookshelves, object: nil)
    }
    
    private func postNotificationForBookshelfUpdate() {
        NotificationCenter.default.post(name: .updatedBookshelves, object: nil)
    }
    
    private func updateTableViewData(for indexPath: IndexPath) {
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func isEditingMode(_ mode: Bool) {
        if mode {
            navigationController?.setToolbarHidden(false, animated: true)
            
            toggleElementsForEditingMode(opacity: 0.0)
        } else {
            navigationController?.setToolbarHidden(true, animated: true)
            footerView.layer.opacity = 1
            toggleElementsForEditingMode(opacity: 1.0)
        }
        
    }
    
    private func toggleElementsForEditingMode(opacity: Float) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            guard let tabBar = self.tabBarController?.tabBar else { return }
            self.footerView.layer.opacity = opacity
            tabBar.layer.opacity = opacity
        }
    }
    
    private func setupView() {

        view.backgroundColor = .systemGray6
        
        title = "Bookshelves"
        
        navigationItem.rightBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BookshelfCell.self, forCellReuseIdentifier: BookshelfCell.reusableIdentifier)
        tableView.register(BookshelfFooter.self, forHeaderFooterViewReuseIdentifier: BookshelfFooter.reusableIdentifier)
        
        //toolbar setup
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let deleteButton: UIBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(didPressDelete))
        self.toolbarItems = [flexible, deleteButton]
    }
    
    @objc func didPressDelete() {
        
//        Problem is: tableView.indexPathForSelectedRows is gonna
//        save the rows you have selected in the order you tapped them.
//        So if you tap the items to delete from top to bottom, you will
//        eventually get an index out of range error.
//        Add selectedRows = selectedRows?.sorted(by: >)to fix the issue.
        
        let selectedRows = tableView.indexPathsForSelectedRows
        guard let selectedRows = selectedRows?.sorted(by: >) else {
            return
        }

        for selectionIndex in selectedRows {
            tableView(tableView, commit: .delete, forRowAt: selectionIndex)
        }
    }
    
    @objc private func updateView() {
        loadingView.startAnimating()
        viewModel.loadData { success in
            DispatchQueue.main.async { [weak self] in
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
}

extension BookshelvesViewController {
    
    // MARK: - TableView
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
        isEditingMode(tableView.isEditing)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { false }
    
    // TODO: - Change storage data order
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
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
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        presentBookshelfDetailViewController(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
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
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        64
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
        
        vc.hidesBottomBarWhenPushed = true
        
        vc.didCreateBookself = { [unowned self] title in
            self.createBookshelf(with: title)
        }
        navigationController?.present(vc, animated: true)
    }
    
    private func createBookshelf(with title: String) {
        viewModel.save(title: title) { [weak self] success in
            guard let self = self else { return }
            if success {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.performBatchUpdates {
                    self.tableView.insertRows(at: [indexPath], with: .none)
                }
                self.postNotificationForBookshelfUpdate()
            }
        }
    }
}
