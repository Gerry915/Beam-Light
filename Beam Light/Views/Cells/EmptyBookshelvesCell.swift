//
//  BookshelvesCell.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

class EmptyBookshelvesCell: UICollectionViewCell {
    
    var handleCreateButtonTap: (() -> Void)?
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "You have no bookshelves"
        label.textColor = .systemGray2
        
        return label
    }()
    
    let createButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 8, leading: 24, bottom: 8, trailing: 24)
        
        config.title = "Create"
        
        button.configuration = config
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let stackView = UIStackView(arrangedSubviews: [emptyLabel, createButton])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 20
        
        addSubview(stackView)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        createButton.addTarget(self, action: #selector(createBookshelves), for: .touchUpInside)
    }
    
    @objc private func createBookshelves() {
        handleCreateButtonTap?()
    }
}
