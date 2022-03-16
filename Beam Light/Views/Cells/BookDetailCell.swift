//
//  BookDetailCell.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/3/2022.
//

import UIKit

class BookDetailCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            authorLabel,
            descriptionLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Public API
    func configure(presentable: SearchResultPresentable, imageService: ImageCacheable) {
        titleLabel.text = presentable.trackName
        authorLabel.text = presentable.artistName
        descriptionLabel.text = presentable.bookDescription.htmlToString
    }
}
