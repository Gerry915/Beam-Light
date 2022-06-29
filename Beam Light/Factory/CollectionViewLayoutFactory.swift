//
//  CollectionViewLayoutFactory.swift
//  Beam Light
//
//  Created by Gerry Gao on 29/6/2022.
//

import UIKit

class CollectionViewLayoutFactory {
	
	func makeHomeViewLayout() -> UICollectionViewLayout {
		
		let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
			layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
			
			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
												  heightDimension: .fractionalHeight(1.0))
			let item = NSCollectionLayoutItem(layoutSize: itemSize)

			let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
												   heightDimension: .estimated(320))
			let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
			
			let section = NSCollectionLayoutSection(group: group)
			
			section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
			
			return section
		}
		
		return layout
	}
	
}

