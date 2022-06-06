//
//  Endpoint.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/6/2022.
//

import Foundation

protocol Endpoint {
	var baseURL: String { get }
	var path: String { get }
	var method: HTTPMethod { get }
	var header: [String: String]? { get }
	var query: [URLQueryItem]? { get }
	var body: [String: String]? { get }
	
	func composeRequest() throws -> URLRequest
}
