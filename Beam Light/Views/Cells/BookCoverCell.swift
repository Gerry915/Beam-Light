//
//  BookCoverCell.swift
//  Beam Light
//
//  Created by Gerry Gao on 11/3/2022.
//

import UIKit

protocol BookCoverCellPresentable {
    var trackName: String { get }
    var artistName: String { get }
    var coverSmall: String { get }
}

extension Book: BookCoverCellPresentable {}

class BookCoverCell: UICollectionViewCell {
    
    private var imageRequest: Cancellable?
    
    var imageService: ImageCacheable?
    
    let imageView = UIImageView()
    
    let authorNameLabel = UILabel()
    let bookNameLabel = UILabel()
    
    var didTapBook: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSetup() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.cornerCurve = .continuous
        
        authorNameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        authorNameLabel.textColor = .systemGray

        let stackView = UIStackView(arrangedSubviews: [imageView, bookNameLabel, authorNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.setCustomSpacing(8, after: imageView)
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCover))
        
        self.addGestureRecognizer(tap)
    }
    override func prepareForReuse() {
        imageRequest?.cancel()
    }
    
    @objc fileprivate func didTapCover() {
        didTapBook?()
    }
    
    // MARK: - Public API
    
    func configuration(presentable: BookCoverCellPresentable) {

        authorNameLabel.text = presentable.artistName
        bookNameLabel.text = presentable.trackName
        
        if let url = URL(string: presentable.coverSmall) {
            imageRequest = imageService?.cache(for: url, completion: { [weak self] image in
                self?.imageView.image = image
            })
        }
    }
}
