//
//  iTunesEndPointTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 5/7/2022.
//

import XCTest
@testable import Beam_Light

class iTunesEndPointTests: XCTestCase {

	func test_baseURL() {
		let sut = iTunesEndpoint.search(searchTerms: "search")
		
		XCTAssertEqual(sut.baseURL, "itunes.apple.com")
	}
	
	func test_method() {
		let sut = iTunesEndpoint.search(searchTerms: "search")
		
		XCTAssertEqual(sut.method, HTTPMethod.GET)
	}
	
	func test_path() {
		let sut = iTunesEndpoint.search(searchTerms: "search")
		
		XCTAssertEqual(sut.path, "/search")
	}
	
	func test_query() {
		let sut = iTunesEndpoint.search(searchTerms: "search")
		
		let media = URLQueryItem(name: "media", value: "ebook")
		XCTAssertTrue(sut.query!.contains(media), "query media")
		
		let limit = URLQueryItem(name: "limit", value: "20")
		XCTAssertTrue(sut.query!.contains(limit), "limit")
		
		
		XCTAssertTrue(sut.query!.contains(where: { $0.name == "term" && $0.value == "search" }))
	}
	
	func test_header() {
		let sut = iTunesEndpoint.search(searchTerms: "search")
		
		XCTAssertEqual(sut.header?.first?.key, "Content-Type")
		XCTAssertEqual(sut.header?.first?.value, "application/json")
	}
	
	func test_body() {
		let sut = iTunesEndpoint.search(searchTerms: "search")
		
		XCTAssertNil(sut.body)
	}
	
	func test_compose_request() throws {
		let sut = iTunesEndpoint.search(searchTerms: "search")
		
		let request = try sut.composeRequest()
		
		XCTAssertNotNil(request)
	}

}
