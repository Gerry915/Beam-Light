//
//  BookHeader.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/3/2022.
//

import UIKit
import SDWebImage

class BookHeader: UICollectionReusableView {
    
    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let bookCoverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layout()
	}
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(loadingView)
        addSubview(bookCoverImageView)
    }
	
	private func layout() {
		NSLayoutConstraint.activate([
			loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
			loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
			bookCoverImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			bookCoverImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			bookCoverImageView.heightAnchor.constraint(equalToConstant: 300),
			bookCoverImageView.widthAnchor.constraint(equalToConstant: 200)
		])
	}
    
    // MARK: - Public API
    func configure(coverImage: String) {
        
        if let url = URL(string: coverImage) {
			bookCoverImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
				self?.loadingView.stopAnimating()
			}
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
		bookCoverImageView.image = nil
        loadingView.startAnimating()
    }
}
