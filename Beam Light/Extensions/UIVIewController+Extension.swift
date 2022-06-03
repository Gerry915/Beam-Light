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
    
    func showAlertView(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertViewController.addAction(cancelAction)
        
		showDetailViewController(alertViewController, sender: self)
    }
}
