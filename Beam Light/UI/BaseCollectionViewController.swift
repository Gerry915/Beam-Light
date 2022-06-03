//
//  BaseCollectionViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

class BaseCollectionViewController: UIViewController {
	lazy var collectionView: UICollectionView = {
		let layout = createLayoutDiffSection()
		
		let cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
		cv.backgroundColor = .systemBackground
		cv.register(EmptyBookshelvesCell.self, forCellWithReuseIdentifier: EmptyBookshelvesCell.reusableIdentifier)
		cv.register(BookshelfCollectionViewCell.self, forCellWithReuseIdentifier: BookshelfCollectionViewCell.reusableIdentifier)
		cv.register(SearchCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionViewHeader.reusableIdentifier)
		
		return cv
	}()
}

extension BaseCollectionViewController {
	
    func setupCollectionView() {
		view.addSubview(collectionView)
    }
    
    func createLayoutDiffSection() -> UICollectionViewLayout {
        
            let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(320))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                
                let header = NSCollectionLayoutBoundarySupplementaryItem.init(layoutSize: .init(widthDimension:.fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
                
                return section
            }
            return layout
        }
}
