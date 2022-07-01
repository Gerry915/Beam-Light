//
//  HomeSearchView.swift
//  Beam Light
//
//  Created by Gerry Gao on 29/6/2022.
//

import UIKit

class HomeSearchView: UIViewController {
	
	var handleSearch: ((String) -> Void)?
	
	let searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.placeholder = "Search your next book..."
		searchBar.searchBarStyle = .minimal
		
		return searchBar
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		searchBar.delegate = self
	}
	
	private func setupUI() {
		view.addSubview(searchBar)
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			searchBar.topAnchor.constraint(equalTo: view.topAnchor),
			searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			searchBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
		])
	}
}

extension HomeSearchView: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else { return }
		
		searchBar.resignFirstResponder()
		handleSearch?(query)
	}
}
