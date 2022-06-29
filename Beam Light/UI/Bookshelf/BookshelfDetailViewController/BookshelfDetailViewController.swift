//
//  BookshelfDetailViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 12/3/2022.
//

import Foundation
import UIKit

class BookshelfDetailViewController: UITableViewController {

    var viewModel: BookshelfViewModel
    
    init(style: UITableView.Style, viewModel: BookshelfViewModel) {
        self.viewModel = viewModel
        
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		setup()
        tableViewConfigure()
        
    }
	
	private func setup() {
		title = viewModel.title
		navigationController?.navigationBar.prefersLargeTitles = true
		view.backgroundColor = .systemBackground
	}
	
	private func tableViewConfigure() {
		tableView.contentInset = .init(top: 0, left: 16, bottom: 0, right: -16)
		tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reusableIdentifier)
	}
}

extension BookshelfDetailViewController {
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.bookCount
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let book = viewModel.generate(for: indexPath.row)
        let bookViewModel = BookViewModel(book: book)
        
        presentBookDetailViewController(with: bookViewModel)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reusableIdentifier, for: indexPath) as! BookTableViewCell
		cell.selectionStyle = .none
        let book = viewModel.generate(for: indexPath.row)
        
        cell.configure(presentable: book)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteBookFromBookshelf(at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    
    private func deleteBookFromBookshelf(at indexPath: IndexPath) {
        viewModel.removeBook(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        DiskStorageService.shared.save(id: viewModel.id, data: viewModel.bookshelf) { done in
            if done {
                NotificationCenter.default.post(name: .updatedBookshelves, object: nil)
            }
        }
    }
}

extension BookshelfDetailViewController {
    private func presentBookDetailViewController(with bookViewModel: BookViewModel) {
        let VC = BookDetailViewController(bookViewModel: bookViewModel, displayToolBar: false)
        VC.title = bookViewModel.title
		show(VC, sender: self)
    }
}
