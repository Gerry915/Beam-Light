//
//  iTunesAPIProviderTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 5/7/2022.
//

import XCTest
@testable import Beam_Light

class iTunesAPIProviderTests: XCTestCase {

	func test_get_search_result_should_fail() async {
		let sut = iTunesAPIProvider(httpClient: MockNetworkingReturnFail())
		
		let result = await sut.getSearchResult(terms: "test")
		
		switch result {
		case .success(_):
			XCTFail("Get result should fail")
		case .failure(let error):
			XCTAssertNotNil(error)
		}
	}
	
	func test_get_search_result_should_return_one_result() async {
		let sut = iTunesAPIProvider(httpClient: MockNetworking())
		
		let result = await sut.getSearchResult(terms: "test")
		
		switch result {
		case .success(let books):
			XCTAssertEqual(books.resultCount, 1)
			XCTAssertEqual(books.results.first?.bookDescription, "test")
		case .failure(_):
			XCTFail("Get result fail")
		}
	}

	private class MockNetworkingReturnFail:HTTPClient {
		func execute<T>(endpoint: Endpoint) async -> Result<T, NetworkError> where T : Decodable, T : Encodable {
			.failure(.badURL("error"))
		}
	}
	
	private class MockNetworking:HTTPClient {
		func execute<T>(endpoint: Endpoint) async -> Result<T, NetworkError> where T : Decodable, T : Encodable {
			let data = Books(resultCount: 1, results: [BookFactory.aBook])

			
			return .success(data as! T)
		}
		
	}
}
