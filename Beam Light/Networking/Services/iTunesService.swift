//
//  iTunesService.swift
//  Beam Light
//
//  Created by Gerry Gao on 10/3/2022.
//

import Foundation

protocol iTunesServiceable {
    func getSearchResult(terms: String, completion: @escaping (Result<Books, NetworkError>) -> Void)
}

struct iTunesService: NetworkServiceable, iTunesServiceable {
    func getSearchResult(terms: String, completion: @escaping (Result<Books, NetworkError>) -> Void) {
        
        makeRequest(with: iTunesEndpoint.search(searchTerms: terms)) { (result: Result<Books, NetworkError>) in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
        
    }
    
    
}
