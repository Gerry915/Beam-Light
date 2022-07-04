//
//  BookshelfFooter.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import UIKit

class BookshelfFooter: UITableViewHeaderFooterView {
    
    var handleButtonTap: (() -> Void)?
    
    let actionButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.filled()
        
        configuration.cornerStyle = .capsule
        
        var attText = AttributedString.init("Create Bookshelf")
//        attText.obliqueness = 0.2 // To set the slant of the text
        attText.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        configuration.contentInsets = .init(top: 8 , leading: 16, bottom: 8, trailing: 16)
        
        configuration.attributedTitle = attText
        
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)

        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc
	private func handleAction() {
        handleButtonTap?()
    }
}
