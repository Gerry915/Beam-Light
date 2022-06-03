//
//  SearchCollectionViewHeader.swift
//  Beam Light
//
//  Created by Gerry Gao on 15/3/2022.
//

import UIKit

class SearchCollectionViewHeader: UICollectionReusableView {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search your next book..."
        searchBar.searchBarStyle = .minimal
        
        return searchBar
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
        
        addSubview(searchBar)
		searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
			searchBar.topAnchor.constraint(equalTo: topAnchor),
			searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
			searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
			searchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
