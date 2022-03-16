//
//  UIVIewController+Extension.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

extension UIViewController {
    func addTapToResignFirstResponder(with action: Selector = #selector(signalResignFirstResponder)) {
        let tap = UITapGestureRecognizer(target: self, action: action)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func signalResignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
