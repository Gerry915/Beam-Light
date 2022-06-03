//
//  LoadingView.swift
//  Beam Light
//
//  Created by Gerry Gao on 21/3/2022.
//

import UIKit

class LoadingView: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func didMoveToSuperview() {
        guard let superview = superview else { return }
        superview.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
    
    private func commonInit() {
        self.startAnimating()
        self.hidesWhenStopped = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
