//
//  SceneDelegate.swift
//  Beam Light
//
//  Created by Gerry Gao on 12/2/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
	
	let mainComposite = MainComposite(viewModel: BookshelvesViewModel(
		getAllUseCase: Resolver.shared.resolve(GetAllBookshelfUseCaseProtocol.self),
					   createBookshelfUseCase: Resolver.shared.resolve(CreateBookshelfUseCaseProtocol.self),
					   deleteBookshelfUseCase: Resolver.shared.resolve(DeleteBookshelfUseCaseProtocol.self),
					   updateBookshelfUseCase: Resolver.shared.resolve(UpdateBookshelfUseCaseProtocol.self)
	))
	
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
     
		window?.rootViewController = mainComposite.compose()
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) { (UIApplication.shared.delegate as? AppDelegate)?.saveContext() }

}

