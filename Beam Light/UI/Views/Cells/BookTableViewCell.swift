//
//  SearchResultCell.swift
//  Beam Light
//
//  Created by Gerry Gao on 1/3/2022.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    private var imageRequest: Cancellable?
    
    lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        
        return view
    }()
    
    let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Book Title"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Author"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        
        return label
    }()
    
    let publishYearLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        label.text = "(2021)"
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 3
        
        return label
    }()
    
    let numberOfRatings: UILabel = {
        let label = UILabel()
        
        label.text = "226 ratings"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        
        return label
    }()
    
    let ratingView = RatingView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override func layoutSubviews() {
        thumbnailImageView.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            loadingView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor)
        ])
    }
    
    private func commonInit() {
        
        contentView.backgroundColor = .systemGray6
        let authorStackView = UIStackView(arrangedSubviews: [authorLabel, publishYearLabel])
        authorStackView.alignment = .leading
        authorStackView.spacing = 4
        let ratingStackView = UIStackView(arrangedSubviews: [ratingView, numberOfRatings])
        ratingStackView.spacing = 10
        
        let contentStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            authorStackView,
            ratingStackView,
            descriptionLabel
        ])
        
        contentStackView.axis = .vertical
        contentStackView.alignment = .top
        contentStackView.spacing = 4
        contentStackView.setCustomSpacing(16, after: ratingStackView)
        
        let HStack = UIStackView(arrangedSubviews: [
            thumbnailImageView,
            contentStackView
        ])
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        HStack.translatesAutoresizingMaskIntoConstraints = false
        HStack.spacing = 8
        contentView.addSubview(HStack)
        
        NSLayoutConstraint.activate([
            HStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            HStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            HStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            HStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        loadingView.startAnimating()
        thumbnailImageView.image = nil
        imageRequest?.cancel()
    }
}

extension BookTableViewCell {
    
    // MARK: - Public API
    
    func configure(presentable: SearchResultPresentable, imageService: ImageCacheable) {
        loadingView.startAnimating()
        titleLabel.text = presentable.title
        authorLabel.text = presentable.author
        ratingView.rating = presentable.averageRating ?? 0
        descriptionLabel.text = presentable.content.htmlToString
        numberOfRatings.text = String(describing: "\(presentable.ratingCount ?? 0) ratings")
        
        if let url = URL(string: presentable.coverSmall) {
            imageRequest = imageService.cache(for: url) { [weak self] image in
                self?.thumbnailImageView.image = image
                self?.loadingView.stopAnimating()
            }
        }
    }
}
