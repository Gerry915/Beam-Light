//
//  SceneDelegate.swift
//  Beam Light
//
//  Created by Gerry Gao on 12/2/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
     
        window?.rootViewController = makeTabView()
        
        window?.makeKeyAndVisible()
    }
    
    func makeTabView() -> MainTabViewController {
		let mainTabViewController = MainTabViewController()
		mainTabViewController.viewControllers = [makeHomeView(), makeBookshelfView()]
        return mainTabViewController
    }
	
	func makeHomeView() -> UINavigationController {
		let containerView = HomeViewContainerView()
		
		let headerView = HomeSearchView()
		
		headerView.handleSearch = { [headerView] query in
			let searchResultViewController = SearchResultViewController(
				viewModel: BooksViewModel(service: iTunesAPIProvider(), terms: query)
			)
			searchResultViewController.hidesBottomBarWhenPushed = true
			headerView.show(searchResultViewController, sender: headerView)
		}
		
		containerView.headerView = headerView
		containerView.listView = makeHomeListView()
		
		return makeNav(for: containerView, title: "Beam Light", image: "light.min")
	}
    
    func makeHomeListView() -> UIViewController {
		
		let viewModel = makeBookshelvesViewModel()
        
		let listView = HomeListView(viewModel: viewModel,
													layout: CollectionViewLayoutFactory().makeHomeViewLayout()
		)
		
		listView.createBookshelf = { [listView] in
			let createBookshelfVC = CreateBookshelfViewController()
			
			if let sheet = createBookshelfVC.sheetPresentationController {
				sheet.detents = [.medium()]
				sheet.prefersGrabberVisible = false
			}
			
			listView.showDetailViewController(createBookshelfVC, sender: listView)
			
			createBookshelfVC.didCreateBookshelf = { title in
				Task {
					await viewModel.create(with: title)
				}
			}
		}
		
		listView.presentBookDetailView = { [weak self, listView] book in
			let viewModel = BookViewModel(book: book)
			let vc = BookDetailViewController(bookViewModel: viewModel, displayToolBar: false)
			vc.title = viewModel.title

			if let nav = self?.makeNav(for: vc, title: viewModel.title, image: nil, largeTitle: false) {
				
				nav.modalPresentationStyle = .pageSheet
				listView.showDetailViewController(nav, sender: listView)
				
			}
		}
		
		listView.presentBookshelf = { [listView] bookshelf in
			let bookshelfViewModel = BookshelfViewModel(updateBookshelfUseCase: Resolver.shared.resolve(UpdateBookshelfUseCaseProtocol.self), bookshelf: bookshelf)
			
			let vc = BookshelfDetailViewController(style: .plain,
												   viewModel: bookshelfViewModel)
			vc.hidesBottomBarWhenPushed = true
			
			listView.show(vc, sender: listView)
		}
		
		return listView
    }
    
    func makeBookshelfView() -> UINavigationController {
        
		let viewModel = makeBookshelvesViewModel()
        
        let bookshelvesViewController = BookshelvesViewController(viewModel: viewModel)
		
        return makeNav(for: bookshelvesViewController, title: "My Bookshelves", image: "books.vertical.circle")
    }
	
	func makeNav(for viewController: UIViewController, title: String?, image: String?, largeTitle: Bool = true) -> UINavigationController {
		
		let navigationVC = UINavigationController(rootViewController: viewController)
		
		viewController.title = title
		
		if let image = image {
			viewController.tabBarItem.title = title
			viewController.tabBarItem.image = UIImage(systemName: image)
		}
		
		navigationVC.navigationBar.prefersLargeTitles = largeTitle
		
		return navigationVC
	}
	
	func makeBookshelvesViewModel() -> BookshelvesViewModel {
		return BookshelvesViewModel(
							getAllUseCase: Resolver.shared.resolve(GetAllBookshelfUseCaseProtocol.self),
							createBookshelfUseCase: Resolver.shared.resolve(CreateBookshelfUseCaseProtocol.self),
							deleteBookshelfUseCase: Resolver.shared.resolve(DeleteBookshelfUseCaseProtocol.self),
							updateBookshelfUseCase: Resolver.shared.resolve(UpdateBookshelfUseCaseProtocol.self)
		)
	}

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) { (UIApplication.shared.delegate as? AppDelegate)?.saveContext() }

}

