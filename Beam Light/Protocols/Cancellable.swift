//
//  Cancellable.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/3/2022.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {}
