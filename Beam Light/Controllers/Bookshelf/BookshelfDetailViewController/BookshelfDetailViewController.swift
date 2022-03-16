//
//  BookshelfDetailViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 12/3/2022.
//

import Foundation
import UIKit

class BookshelfDetailViewController: UITableViewController {
    
    var imageService: ImageService
    var viewModel: BookshelfDetailViewModel
    
    init(style: UITableView.Style, viewModel: BookshelfDetailViewModel, imageService: ImageService) {
        self.imageService = imageService
        self.viewModel = viewModel
        
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bookshelf Detail"
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reusableIdentifier)
    }
}

extension BookshelfDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reusableIdentifier, for: indexPath) as! BookTableViewCell
        
        if let presentable = viewModel.getBook(for: indexPath.row) {
            cell.configure(presentable: presentable, imageService: imageService)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
}
