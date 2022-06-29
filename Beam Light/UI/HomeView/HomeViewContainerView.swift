//
//  HomeViewContainerView.swift
//  Beam Light
//
//  Created by Gerry Gao on 29/6/2022.
//

import UIKit

class HomeViewContainerView: UIViewController {
	
	var headerView: UIViewController?
	var listView: UIViewController?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
	}
	
	private func setupUI() {
		guard let headerView = headerView, let listView = listView else {
			return
		}

		add(headerView)
		add(listView)
		
		headerView.view.translatesAutoresizingMaskIntoConstraints = false
		listView.view.translatesAutoresizingMaskIntoConstraints = false
			
		NSLayoutConstraint.activate([
			headerView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			headerView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			headerView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			listView.view.topAnchor.constraint(equalTo: headerView.view.bottomAnchor),
			listView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			listView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			listView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
	
}

