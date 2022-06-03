//
//  ReusableView.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import UIKit

protocol ReusableView {
    static var reusableIdentifier: String { get }
}

extension ReusableView {
    static var reusableIdentifier: String {
        get {
            return String(describing: self)
        }
    }
}

//extension UICollectionViewCell: ReusableView {}
extension UITableViewCell: ReusableView {}
extension UICollectionReusableView: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}
