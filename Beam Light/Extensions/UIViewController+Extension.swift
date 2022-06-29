//
//  UIViewController+Extension.swift
//  Beam Light
//
//  Created by Gerry Gao on 28/6/2022.
//

import UIKit

extension UIViewController {
	
	func add(_ child: UIViewController) {
		
		addChild(child)
		
		view.addSubview(child.view)
		child.didMove(toParent: self)
	}

	func remove() {
		// Just to be safe, we check that this view controller
		// is actually added to a parent before removing it.
		guard parent != nil else {
			return
		}

		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
	
	func fadeOut() {
		self.view.alpha = 0
		self.view.transform = .init(translationX: 0, y: 50)
	}
	
	func fadeIn() {
		self.view.animate(inParallel: [
			.fadeIn(duration: 0.25),
			.transformIdentity(duration: 0.35)
		])
	}
}
