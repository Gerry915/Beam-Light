//
//  SearchResultViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/3/2022.
//

import UIKit

class BooksViewModel {
    
    private(set) var books: Books?
    
    var service: iTunesServiceable
    
    init(service: iTunesServiceable) {
        self.service = service
    }
    
    var resultCount: Int {
        books?.resultCount ?? 0
    }
    
    func getBookForIndex(index: Int) -> Book? {
        books?.results[index] ?? nil
    }
    
    func fetchData(with terms: String, completion: @escaping (Bool) -> Void) {
        service.getSearchResult(terms: terms) { (result: Result<Books, NetworkError>) in
            switch result {
            case .success(let success):
                self.books = success
                completion(true)
            case .failure(let failure):
                print(failure)
                completion(false)
            }
        }
    }
}
