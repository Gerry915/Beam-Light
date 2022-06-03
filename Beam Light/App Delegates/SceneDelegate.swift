//
//  SceneDelegate.swift
//  Beam Light
//
//  Created by Gerry Gao on 12/2/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    // Image Service
    private var imageService = ImageService(
        maximumCacheSizeInMemory: 512 * 1024,
        maximumCacheSizeOnDisk: 50 * 1024
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
     
        window?.rootViewController = composeTabViewController()
        
        window?.makeKeyAndVisible()
        
    }
    
    func composeTabViewController() -> MainTabViewController {
        let homeViewController = composeHomeViewController(imageService: imageService)
        let bookshelvesViewController = composeBookshelfViewController(imageService: imageService)
        
        return MainTabViewController(viewControllers: [homeViewController,bookshelvesViewController])
    }
    
    func composeHomeViewController(imageService: ImageCacheable) -> UINavigationController {
		
		let viewModel = BookshelvesViewModel(loader: DiskStorageService.shared, getAllUseCase: Resolver.shared.resolve(GetAllBookshelfUseCaseProtocol.self), createBookshelfUseCase: Resolver.shared.resolve(CreateBookshelfUseCaseProtocol.self))
        
        let homeTabItem = UITabBarItem(title: "Beam Light", image: UIImage(systemName: "light.min"), tag: 0)
        
        let homeViewController = HomeViewController(imageService: imageService, viewModel: viewModel)
        
        let homeNav = UINavigationController(rootViewController: homeViewController)
        homeNav.tabBarItem = homeTabItem
        
        return homeNav
    }
    
    func composeBookshelfViewController(imageService: ImageService) -> UINavigationController {
        
		let viewModel = BookshelvesViewModel(loader: DiskStorageService.shared, getAllUseCase: Resolver.shared.resolve(GetAllBookshelfUseCaseProtocol.self), createBookshelfUseCase: Resolver.shared.resolve(CreateBookshelfUseCaseProtocol.self)
		)
        
        let bookshelvesViewController = BookshelvesViewController(imageService: imageService, viewModel: viewModel)
        bookshelvesViewController.storageService = DiskStorageService.shared
        let bookshelvesNavController = UINavigationController(rootViewController: bookshelvesViewController)
        let bookshelvesTabItem = UITabBarItem(title: "Bookshelves", image: UIImage(systemName: "books.vertical.circle"), tag: 1)
        bookshelvesNavController.tabBarItem = bookshelvesTabItem
        
        return bookshelvesNavController
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
    }

}

