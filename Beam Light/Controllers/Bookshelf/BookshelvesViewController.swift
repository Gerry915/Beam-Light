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
    
    var viewModel: BookshelfViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    var imageService: ImageService
    
    // MARK: - Init
    
    init(imageService: ImageService) {
        self.imageService = imageService
        
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    fileprivate func setupView() {

        view.backgroundColor = .systemGray6
        
        title = "Bookshelves"
        
        navigationItem.rightBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BookshelfCell.self, forCellReuseIdentifier: BookshelfCell.reusableIdentifier)
        tableView.register(BookshelfFooter.self, forHeaderFooterViewReuseIdentifier: BookshelfFooter.reusableIdentifier)
        
        
        //toolbar setup
        self.navigationController?.setToolbarHidden(false, animated: false)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let deleteButton: UIBarButtonItem = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(didPressDelete))
        self.toolbarItems = [flexible, deleteButton]
        self.navigationController?.toolbar.barTintColor = UIColor.white
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
    
    fileprivate func updateView() {
        // Load bookshelf data form storage service
        DiskStorageService.shared.fetchAll { [weak self] (result: Result<[Bookshelf], Error>) in
            switch result {
            case .success(let result):
                guard let self = self else { return }
                self.viewModel = BookshelfViewModel(model: result)
                NotificationCenter.default.post(name: .updatedBookshelves, object: nil)
            case .failure(let failure):
                print(failure)
            }
        }
        tableView.reloadData()
    }
}

extension BookshelvesViewController {
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { true }
    
    // TODO: - Change storage data order
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookshelfFooter.reusableIdentifier) as! BookshelfFooter
        footer.handleButtonTap = presentCreateBookshelfViewController
        
        return footer
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.bookshelfCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookshelfCell.reusableIdentifier, for: indexPath) as! BookshelfCell
        
        // TODO: - Need to change to the new API for iOS 14 and above:
        // https://medium.com/swlh/ios-14-modern-cell-configuration-for-beginners-programmatically-2a1be3f12a90
        
        cell.accessoryType = .disclosureIndicator
        
        if let viewModel = viewModel {
            let model = viewModel.getBookshelf(for: indexPath.row)

            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = "\(model.books.count) books"
        }
        
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
            if let bookshelfID = viewModel?.getBookshelf(for: indexPath.row).id.uuidString {
                DiskStorageService.shared.delete(id: bookshelfID) { [weak self] done in
                    guard let self = self else { return }
                    if done {
                        DispatchQueue.main.async {
                            self.updateView()
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }
    
    private func presentBookshelfDetailViewController(for indexPath: IndexPath) {
        if let bookshelf = viewModel?.getBookshelf(for: indexPath.row) {
            let viewModel = BookshelfDetailViewModel(bookshelf: bookshelf)
            
            let vc = BookshelfDetailViewController(style: .insetGrouped, viewModel: viewModel, imageService: imageService)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func presentCreateBookshelfViewController() {
        
        let vc = CreateBookshelfViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.didCreateBookself = { [unowned self] bookshelf in
            self.updateBookshelf(bookshelf: bookshelf)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func updateBookshelf(bookshelf: Bookshelf) {
        
        viewModel?.model.append(bookshelf)
        
        tableView.reloadData()
        
        guard let service = storageService else { return }
        service.save(id: bookshelf.id.uuidString, data: bookshelf) { done in
            NotificationCenter.default.post(name: .updatedBookshelves, object: nil)
        }
    }
}
