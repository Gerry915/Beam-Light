//
//  BookshelfListViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 14/3/2022.
//

import UIKit

class BookshelfListViewController: UITableViewController {
    
    var bookViewModel: BookViewModel
    var bookshelvesViewModel: BookshelvesViewModel
    
    lazy var loadingView: UIActivityIndicatorView = LoadingView(style: .medium)
    
    init(bookshelvesViewModel: BookshelvesViewModel,
         bookViewModel: BookViewModel, style: UITableView.Style = .insetGrouped) {
        
        self.bookViewModel = bookViewModel
        self.bookshelvesViewModel = bookshelvesViewModel
        
        super.init(style: style)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        title = "My Bookshelf"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "listCellID")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loadingView)
        
        bookshelvesViewModel.loadData { success in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if success {
                    self.tableView.reloadData()
                    self.loadingView.stopAnimating()
                } else {
                    self.showAlertView(title: "Error", message: "Cannot Load Data")
                }
            }
        }
    }
}

extension BookshelfListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookshelvesViewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCellID", for: indexPath)
        
        let presentable = bookshelvesViewModel.getBookshelf(for: indexPath.row)
        
        // TODO: Update Content method
        cell.textLabel?.text = presentable.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        bookshelvesViewModel.saveBookToBookshelf(at: indexPath.row, with: bookViewModel.book) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .updatedBookshelves, object: nil)
            } else {
                print("TODO: Show Alert")
            }
        }
    }
}

extension Notification.Name {
    static let updatedBookshelves = Notification.Name("updatedBookshelves")
}
