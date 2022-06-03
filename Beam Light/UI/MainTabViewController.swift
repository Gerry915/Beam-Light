//
//  MainTabViewController.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.delegate = self
        tabBar.backgroundColor = .systemGray6
    }
    
    init(viewControllers: [UIViewController]) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = viewControllers
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
