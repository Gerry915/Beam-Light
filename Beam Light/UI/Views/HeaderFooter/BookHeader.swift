//
//  BookHeader.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/3/2022.
//

import UIKit

class BookHeader: UICollectionReusableView {
    
    var cancellable: Cancellable?
    
    let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(bookCoverImageView)
        NSLayoutConstraint.activate([
            bookCoverImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bookCoverImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bookCoverImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            bookCoverImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])
        
    }
    
    // MARK: - Public API
    func configure(coverImage: String, imageService: ImageCacheable) {
        
        if let url = URL(string: coverImage) {
            cancellable = imageService.cache(for: url) { [weak self] image in
                self?.bookCoverImageView.image = image
                self?.loadingView.stopAnimating()
            }
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable?.cancel()
        loadingView.startAnimating()
    }
}
