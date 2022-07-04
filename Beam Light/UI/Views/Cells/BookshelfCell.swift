//
//  BookshelfCell.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import UIKit

class BookshelfCell: UITableViewCell {
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .clear
		backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(title: String, bookCount: Int) {
		
		var content = self.defaultContentConfiguration()
		
        content.text = title
        content.secondaryText = "\(bookCount) books"
        
        self.accessoryType = .disclosureIndicator
        
        self.contentConfiguration = content
    }
}
