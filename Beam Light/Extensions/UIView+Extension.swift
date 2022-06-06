//
//  UIView+Extension.swift
//  Beam Light
//
//  Created by Gerry Gao on 6/6/2022.
//

import UIKit

extension UIView {
	func animate(_ animations: [Animation]) {
		guard !animations.isEmpty else {
			return
		}
		
		var animations = animations
		let animation = animations.removeFirst()
		
		UIView.animate(withDuration: animation.duration, delay: 0.0, options: .curveEaseInOut) {
			animation.closure(self)
		} completion: { _ in
			self.animate(animations)
		}

	}
}


