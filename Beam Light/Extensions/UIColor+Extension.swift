//
//  UIColor+Extension.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue:  .random(in: 0...1),
            alpha: 1.0
        )
    }
}
