//
//  SearchCell.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
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
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        welcomeLabel.setContentHuggingPriority(.required, for: .vertical)
        welcomeLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
