//
//  Endpoint.swift
//  Beam Light
//
//  Created by Gerry Gao on 16/2/2022.
//

import Foundation

protocol Endpoint {
    var baseURLString: String { get }
    var headers: [String: String]? { get }
    var body: [String: String]? { get }
    var method: HTTPMethod { get }
    var path: String { get }
    
    func buildURL() -> URL
}
