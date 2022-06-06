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
		label.font = .systemFont(ofSize: 14, weight: .semibold)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        
        return label
    }()
    
	lazy var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
		layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            authorLabel,
            descriptionLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
	
	private func layout() {
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
    
    // MARK: - Public API
    func configure(presentable: SearchResultPresentable) {
        titleLabel.text = presentable.title
        authorLabel.text = presentable.author
        descriptionLabel.text = presentable.content.htmlToString
    }
}
