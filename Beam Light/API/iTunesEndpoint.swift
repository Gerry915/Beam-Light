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
        
    var baseURLString: String {
        return CONSTANT.ENDPOINT.iTunesURLString
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
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .search(let term):
            var queryItems = [URLQueryItem(name: "media", value: "ebook"), URLQueryItem(name: "limit", value: "20")]
            let searchTerms = URLQueryItem(name: "term", value: term)
            queryItems.append(searchTerms)
            return queryItems
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var body: [String : String]? {
        return nil
    }
        
//    func buildRequest(headers: [String: String]?, body: Data?) -> URLRequest {
//        let url = buildURL()
//        
//        var request = URLRequest(url: url)
//        
//        headers?.forEach({ (key, value) in
//            request.addValue(value, forHTTPHeaderField: key)
//        })
//        
//        request.httpBody = body
//        
//        return request
//    }
    
    func buildURL() -> URL {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseURLString
        urlComponents.path = self.path
        urlComponents.queryItems = self.queryItems
        
        guard let url = urlComponents.url else {
            fatalError("Invalid URL")
        }
        
        return url
    }
}

