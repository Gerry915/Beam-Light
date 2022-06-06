//
//  BookshelfCell.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import UIKit

class BookshelfCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: BookshelfCell.reusableIdentifier)
		contentView.backgroundColor = .clear
		backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, bookCount: Int) {
        var content = self.defaultContentConfiguration()
        content.text = title
        content.secondaryText = "\(bookCount) books"
        
        self.accessoryType = .disclosureIndicator
        
        self.contentConfiguration = content
    }
}
