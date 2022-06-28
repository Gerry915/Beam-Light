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
        let homeViewController = makeHomeView()
        let bookshelvesViewController = makeBookshelfView()
        
        return MainTabViewController(viewControllers: [homeViewController,bookshelvesViewController])
    }
    
    func makeHomeView() -> UINavigationController {
		
		let viewModel = BookshelvesViewModel(
						getAllUseCase: Resolver.shared.resolve(GetAllBookshelfUseCaseProtocol.self),
						createBookshelfUseCase: Resolver.shared.resolve(CreateBookshelfUseCaseProtocol.self),
						deleteBookshelfUseCase: Resolver.shared.resolve(DeleteBookshelfUseCaseProtocol.self), updateBookshelfUseCase: Resolver.shared.resolve(UpdateBookshelfUseCaseProtocol.self)
		)
        
        let homeViewController = HomeViewController(viewModel: viewModel)
		
        return makeNav(for: homeViewController, title: "Beam Light", image: "light.min")
    }
    
    func makeBookshelfView() -> UINavigationController {
        
		let viewModel = BookshelvesViewModel(
							getAllUseCase: Resolver.shared.resolve(GetAllBookshelfUseCaseProtocol.self),
							createBookshelfUseCase: Resolver.shared.resolve(CreateBookshelfUseCaseProtocol.self),
							deleteBookshelfUseCase: Resolver.shared.resolve(DeleteBookshelfUseCaseProtocol.self), updateBookshelfUseCase: Resolver.shared.resolve(UpdateBookshelfUseCaseProtocol.self)
		)
        
        let bookshelvesViewController = BookshelvesViewController(viewModel: viewModel)
		
        return makeNav(for: bookshelvesViewController, title: "My Bookshelves", image: "books.vertical.circle")
    }
	
	func makeNav(for viewController: UIViewController, title: String, image: String) -> UINavigationController {
		
		let navigationVC = UINavigationController(rootViewController: viewController)
		
		viewController.title = title
		viewController.tabBarItem.title = title
		viewController.tabBarItem.image = UIImage(systemName: image)
		
		return navigationVC
	}

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) { (UIApplication.shared.delegate as? AppDelegate)?.saveContext() }

}

