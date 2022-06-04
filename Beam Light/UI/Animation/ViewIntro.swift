//
//  ViewIntro.swift
//  Beam Light
//
//  Created by Gerry Gao on 4/6/2022.
//

import UIKit

protocol ViewIntro {
	func startState(alpha: CGFloat, transform: CGAffineTransform, target: UIView)
	func intro(duration: Double, target: UIView)
}
