//
//  Animation.swift
//  Beam Light
//
//  Created by Gerry Gao on 6/6/2022.
//

import UIKit

struct Animation {
	var duration: TimeInterval
	var closure: (UIView) -> Void
}

extension Animation {
	static func fadeIn(duration: TimeInterval) -> Animation {
		return Animation(duration: duration, closure: { $0.alpha = 1 })
	}
	
	static func fadeOut(duration: TimeInterval) -> Animation {
		return Animation(duration: duration, closure: { $0.alpha = 0 })
	}
	
	static func transformIdentity(duration: TimeInterval) -> Animation {
		return Animation(duration: duration, closure: { $0.transform = .identity })
	}
}
