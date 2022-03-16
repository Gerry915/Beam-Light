//
//  BookshelfListViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 14/3/2022.
//

import UIKit

class BookshelfListViewController: UITableViewController {
    
    var book: Book
    var viewModel: BookshelfViewModel {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(viewModel: BookshelfViewModel,
         book: Book) {
        self.viewModel = viewModel
        self.book = book
        
        super.init(style: .insetGrouped)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        title = "My Bookshelf"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "listCellID")
        print(book.artistName)
    }
}

extension BookshelfListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.bookshelfCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCellID", for: indexPath)
        
        let presentable = viewModel.getBookshelf(for: indexPath.row)
        
        cell.textLabel?.text = presentable.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = viewModel.getBookshelf(for: indexPath.row)
        
        print("add to bookshelf \(selected.title)")
        updateBookshelf(bookshelf: selected)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private func updateBookshelf(bookshelf: Bookshelf) {
        var updateItem = bookshelf
        updateItem.books.append(book)
        DiskStorageService.shared.save(id: updateItem.id.uuidString, data: updateItem) { done in
            if done {
                print("Finished update item with id: \(updateItem.id.uuidString)")
                NotificationCenter.default.post(name: .updatedBookshelves, object: nil)
            }
        }
    }
}

extension Notification.Name {
    static let updatedBookshelves = Notification.Name("updatedBookshelves")
}
