//
//  PaddingTextField.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import UIKit

class PaddingTextField: UITextField {
    
    private let padding = UIEdgeInsets.init(top: 8, left: 4, bottom: 8, right: 32)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func setUnderLine() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: 28 - width, width:  self.frame.size.width - 10, height: 28)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
