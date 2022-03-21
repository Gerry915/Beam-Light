//
//  BookshelfCollectionViewCell.swift
//  Beam Light
//
//  Created by Gerry Gao on 11/3/2022.
//

import Foundation
import UIKit

class BookshelfCollectionViewCell: UICollectionViewCell {
    
    var imageService: ImageCacheable?
    
    var showBookDetailViewHandler: ((Book) -> Void)?
    var showBookshelfDetailHandler: ((Bookshelf) -> Void)?
    
    var viewModel: BookshelfViewModel? {
        didSet {
            if viewModel?.bookCount != 0 {
                emptyBookMessage.isHidden = true
            }
            collectionView.reloadData()
        }
    }
    
    let emptyBookMessage: UILabel = {
        let lb = UILabel()
        lb.text = "You have no books in this shelf"
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: 18, weight: .semibold)
        lb.textColor = .systemGray3
        
        return lb
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20, weight: .light)
        
        return lb
    }()
    
    let seeAllButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        var attText = AttributedString.init("SEE ALL")
        attText.font = .systemFont(ofSize: 14, weight: .medium)
        config.attributedTitle = attText
        
        button.configuration = config
        
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = self.setupCollectionViewLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return view
    }()
    
    override func prepareForReuse() {
        emptyBookMessage.isHidden = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
        setupCollectionView()
   
    }
    
    private func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        // Groups
        // Inner Group
        let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let innerGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitems: [item])
        
        innerGroup.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 8)
        
        // Nested Group
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1.0))
        let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [innerGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.orthogonalScrollingBehavior = .continuous
        
        section.contentInsets = .init(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func commonInit() {
        
        collectionView.backgroundColor = .systemGray6
        
        let hStack = UIStackView(arrangedSubviews: [titleLabel, seeAllButton])
        hStack.axis = .horizontal
        
        let vStack = UIStackView(arrangedSubviews: [hStack, collectionView])
        
        vStack.axis = .vertical
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        addSubview(emptyBookMessage)
        emptyBookMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyBookMessage.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyBookMessage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        seeAllButton.addTarget(self, action: #selector(handleSeeAllButtonPressed), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(BookCoverCell.self, forCellWithReuseIdentifier: BookCoverCell.reusableIdentifier)
    }
}

extension BookshelfCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.bookCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCoverCell.reusableIdentifier, for: indexPath) as! BookCoverCell
        
        cell.didTapBook = { [weak self] in
            guard let self = self else { return }
           
            guard let book = self.viewModel?.generate(for: indexPath.row) else { return }
            
            self.didTapCover(book: book)
        }
        
        if let presentable = viewModel?.generate(for: indexPath.row) {
            cell.imageService = imageService
            cell.configuration(presentable: presentable)
        }
        
        return cell
    }
    
    private func didTapCover(book: Book) {
        showBookDetailViewHandler?(book)
    }
    
    @objc private func handleSeeAllButtonPressed() {
        guard let bookshelf = viewModel?.bookshelf else { return }
        showBookshelfDetailHandler?(bookshelf)
    }
}
