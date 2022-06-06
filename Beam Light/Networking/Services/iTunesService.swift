//
//  iTunesService.swift
//  Beam Light
//
//  Created by Gerry Gao on 10/3/2022.
//

import Foundation

protocol iTunesServiceable {
	func getSearchResult(terms: String) async -> Result<Books, NetworkError>
}

struct iTunesService: HTTPClient, iTunesServiceable {
	typealias ModelType = Books
	
	func getSearchResult(terms: String) async -> Result<Books, NetworkError> {
		await fetch(endpoint: iTunesEndpoint.search(searchTerms: terms))
	}

}
