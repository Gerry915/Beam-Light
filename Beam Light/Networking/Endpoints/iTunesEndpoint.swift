//
//  iTunesAPI.swift
//  Beam Light
//
//  Created by Gerry Gao on 28/2/2022.
//

import Foundation

enum iTunesEndpoint: Endpoint {
    case search(searchTerms: String)
}

extension iTunesEndpoint {
        
    var baseURL: String {
        return CONSTANT.ENDPOINT.iTunesBase
    }
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
		case .search(let term):
            var queryItems = [URLQueryItem(name: "media", value: "ebook"), URLQueryItem(name: "limit", value: "20")]
            let searchTerms = URLQueryItem(name: "term", value: term)
            queryItems.append(searchTerms)
            return queryItems
        }
    }
    
    var header: [String : String]? {
		switch self {
		case .search:
			return [
					"Content-Type": "application/json"
			]
		}
    }
    
    var body: [String : String]? {
		switch self {
		case .search:
			return nil
		}
    }
    
    func composeRequest() throws -> URLRequest {
		
		var urlComponent = URLComponents(string: self.baseURL + self.path)

		urlComponent?.scheme = "https"
		
		if let query = query {
			urlComponent?.queryItems = query
		}

		guard let url = urlComponent?.url else {
			throw NetworkError.badURL("Cannot get URL from url component")
		}

		var request = URLRequest(url: url)

		request.httpMethod = self.method.rawValue
		request.allHTTPHeaderFields = self.header
		
		if let body = body {
			do {
				let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
				request.httpBody = bodyData
			} catch {
				throw NetworkError.invalidJSON("Cannot get body json data")
			}
		}
		
		return request
    }
}

