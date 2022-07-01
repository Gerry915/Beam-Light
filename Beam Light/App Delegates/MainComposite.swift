//
//  MainComposite.swift
//  Beam Light
//
//  Created by Gerry Gao on 29/6/2022.
//

import UIKit

protocol MainComposing {
	func compose() -> UIViewController
}

class MainComposite {
	
	private let viewModel: BookshelvesViewModel
	
	init(viewModel: BookshelvesViewModel) {
		self.viewModel = viewModel
	}
	
	func compose() -> UIViewController {
		let mainTabViewController = MainTabViewController()
		
		mainTabViewController.viewControllers = [
			makeHomeView(),
			makeBookshelfView()
		]
		
		return mainTabViewController
	}
	
	private func makeHomeView() -> UIViewController {
		
		let containerView = HomeViewContainerView()
		
		containerView.headerView = makeHeaderView()
		containerView.listView = makeHomeListView()
		
		return _makeNav(for: containerView, title: "Beam Light", image: "light.min")
	}
	
	private func makeHeaderView() -> UIViewController {
		let headerView = HomeSearchView()
		
		headerView.handleSearch = { [headerView] query in
			let searchResultViewController = SearchResultViewController(
				viewModel: BooksViewModel(service: iTunesAPIProvider(), terms: query)
			)
			searchResultViewController.hidesBottomBarWhenPushed = true
			headerView.show(searchResultViewController, sender: headerView)
		}
		
		return headerView
	}
	
	private func makeHomeListView() -> UIViewController {
		
		let listView = HomeListView(viewModel: viewModel,
													layout: CollectionViewLayoutFactory().makeHomeViewLayout()
		)
		
		listView.createBookshelf = { [listView] in
			
			let createBookshelfVC = CreateBookshelfViewController()
			
			createBookshelfVC.didCreateBookshelf = { [weak self] title in
				if let vm = self?.viewModel {
					Task {
						await vm.create(with: title)
					}
				}
			}
			
			if let sheet = createBookshelfVC.sheetPresentationController {
				sheet.detents = [.medium()]
				sheet.prefersGrabberVisible = false
			}
			
			listView.showDetailViewController(createBookshelfVC, sender: listView)
	
		}
		
		listView.presentBookDetailView = { [weak self] book in
			
			let viewModel = BookViewModel(book: book)
			
			let vc = BookDetailViewController(bookViewModel: viewModel, displayToolBar: false)

			if let nav = self?._makeNav(for: vc, title: viewModel.title, image: nil, largeTitle: false) {
				nav.modalPresentationStyle = .pageSheet
				
				listView.showDetailViewController(nav, sender: listView)
			}
		}
		
		listView.presentBookshelf = { [listView] bookshelf in
			let bookshelfViewModel = BookshelfViewModel(updateBookshelfUseCase: Resolver.shared.resolve(UpdateBookshelfUseCaseProtocol.self), bookshelf: bookshelf)
			
			let vc = BookshelfDetailViewController(style: .plain, viewModel: bookshelfViewModel)
			vc.hidesBottomBarWhenPushed = true
			
			listView.show(vc, sender: listView)
		}
		
		return listView
	}
	
	private func makeBookshelfView() -> UIViewController {
		
		let bookshelvesViewController = BookshelvesViewController(viewModel: viewModel)
		
		return _makeNav(for: bookshelvesViewController, title: "My Bookshelves", image: "books.vertical.circle")
	}
	

}

extension MainComposite {
	private 	func _makeNav(for viewController: UIViewController, title: String?, image: String?, largeTitle: Bool = true) -> UINavigationController {
		
		let navigationVC = UINavigationController(rootViewController: viewController)
		
		viewController.title = title
		
		if let image = image {
			viewController.tabBarItem.title = title
			viewController.tabBarItem.image = UIImage(systemName: image)
		}
		
		navigationVC.navigationBar.prefersLargeTitles = largeTitle
		
		return navigationVC
	}
}
