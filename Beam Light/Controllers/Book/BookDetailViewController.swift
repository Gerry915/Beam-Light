//
//  BookDetailViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/3/2022.
//

import UIKit

class BookDetailViewController: UICollectionViewController {
    
    var bookViewModel: BookViewModel
    var imageService: ImageCacheable
    var displayToolBar: Bool = true
    
    private let footerID = "footerID"
    
    convenience init(bookViewModel: BookViewModel, imageService: ImageCacheable, displayToolBar: Bool) {
        self.init(bookViewModel: bookViewModel, imageService: imageService)
        
        self.displayToolBar = displayToolBar
    }

    init(bookViewModel: BookViewModel,
         imageService: ImageCacheable
        ) {
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemLayoutSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading, absoluteOffset: .zero)
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom, absoluteOffset: .init(x: 0, y: 30))
        
        section.boundarySupplementaryItems = [header, footer]
        
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let layout = StretchyHeaderLayout(section: section, headerHeight: 300)
        
        self.bookViewModel = bookViewModel
        self.imageService = imageService
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("No implementation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if displayToolBar {
            setupNavigationBar()
        }
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToBookShelf))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func addToBookShelf() {
        let sheetView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionAdd = UIAlertAction(title: "Add to a Bookshelf", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.handleAddToBookshelf()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("cancel")
        }
        
        sheetView.addAction(actionAdd)
        sheetView.addAction(actionCancel)
        
        present(sheetView, animated: true, completion: nil)
    }
    
    @objc private func openBook() {
        print("TODO: Open book in books app")
    }
    
    private func handleAddToBookshelf() {
        print("Handle Add to bookshelf")
        
        let bookshelvesViewModel = BookshelvesViewModel(loader: DiskStorageService.shared)
        
        let VC = BookshelfListViewController(bookshelvesViewModel: bookshelvesViewModel, bookViewModel: bookViewModel)
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.register(BookDetailCell.self, forCellWithReuseIdentifier: BookDetailCell.reusableIdentifier)
        collectionView.register(BookHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BookHeader.reusableIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID)
        collectionView.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
    }
    
}

extension BookDetailViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerID, for: indexPath)
            
            var config = UIButton.Configuration.filled()
            config.title = "Open in Book"
            config.cornerStyle = .capsule
            
            let button = UIButton(configuration: config)
            button.addTarget(self, action: #selector(openBook), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            footerView.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
            ])
            
            return footerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BookHeader.reusableIdentifier, for: indexPath) as! BookHeader
            
            headerView.configure(coverImage: bookViewModel.coverLarge, imageService: imageService)

            return headerView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookDetailCell.reusableIdentifier, for: indexPath) as! BookDetailCell
        
        cell.configure(presentable: bookViewModel, imageService: imageService)
        
        return cell
    }
}
