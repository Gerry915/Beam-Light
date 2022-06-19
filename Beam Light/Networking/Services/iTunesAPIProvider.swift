//
//  iTunesService.swift
//  Beam Light
//
//  Created by Gerry Gao on 10/3/2022.
//

import Foundation

protocol iTunesProviding {
	func getSearchResult(terms: String) async -> Result<Books, NetworkError>
}

struct iTunesAPIProvider: HTTPClient, iTunesProviding {
	
	func getSearchResult(terms: String) async -> Result<Books, NetworkError> {
		await execute(endpoint: iTunesEndpoint.search(searchTerms: terms))
	}

}
