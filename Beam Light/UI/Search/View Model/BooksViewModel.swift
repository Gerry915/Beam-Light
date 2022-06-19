//
//  SearchResultViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/3/2022.
//

import UIKit

class BooksViewModel {
    
    @Published private(set) var books: Books?
    
    private var service: iTunesProviding
	private var terms: String
    
	init(service: iTunesProviding, terms: String) {
		self.service = service
		self.terms = terms
    }
	
	func generate(for idx: Int) -> Book? {
		books?.results[idx] ?? nil
	}
	
	func fetch() async {
		let result = await service.getSearchResult(terms: terms)
		if case let .success(data) = result {
			books = data
		}
	}
}
