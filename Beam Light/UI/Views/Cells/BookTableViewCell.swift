//
//  SearchResultCell.swift
//  Beam Light
//
//  Created by Gerry Gao on 1/3/2022.
//

import UIKit
import SDWebImage

class BookTableViewCell: UITableViewCell {
    
    lazy var loadingView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        
        return view
    }()
    
    let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
		view.alpha = 0
		view.layer.cornerRadius = 3
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Book Title"
		label.font = .systemFont(ofSize: 18, weight: .medium)
        
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
    
    override func layoutSubviews() {}
    
    private func commonInit() {
        
		contentView.backgroundColor = .clear
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
		contentStackView.distribution = .fillProportionally
        
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
            HStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            HStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            HStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            HStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
		
		contentView.addSubview(loadingView)
		NSLayoutConstraint.activate([
			loadingView.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
			loadingView.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor)
		])
		
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        loadingView.startAnimating()
		thumbnailImageView.alpha = 0
        thumbnailImageView.image = nil
    }
}

extension BookTableViewCell {
    
    // MARK: - Public API
    
    func configure(presentable: Book) {
        loadingView.startAnimating()
		titleLabel.text = presentable.trackName
		authorLabel.text = presentable.artistName
		ratingView.rating = presentable.averageUserRating ?? 0
		descriptionLabel.text = presentable.bookDescription.htmlToString
		numberOfRatings.text = String(describing: "\(presentable.userRatingCount ?? 0) ratings")
        
		
		if let url = URL(string: presentable.coverSmall) {
			
			thumbnailImageView.sd_setImage(with: url) { [weak self] image, error, cacheType, url in
				guard let self = self else { return }
				UIView.animate(withDuration: 0.25, delay: 0.0) {
					self.loadingView.stopAnimating()
					self.thumbnailImageView.alpha = 1
				}
			}
		}
    }
}
