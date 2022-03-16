//
//  SearchCollectionViewHeader.swift
//  Beam Light
//
//  Created by Gerry Gao on 15/3/2022.
//

import UIKit

class SearchCollectionViewHeader: UICollectionReusableView {
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "What are \nyou reading today?"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 32, weight: .thin)
        
        return label
    }()
    
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
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, searchBar])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
