//
//  BooksModelTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 28/6/2022.
//

import XCTest
@testable import Beam_Light

class BooksModelTests: XCTestCase {

	func test_can_init_instance() {
		let sut = Books(resultCount: 1, results: [])
		
		XCTAssertNotNil(sut, "init instance")
	}
	
	func test_can_init_with_correct_book() {
		let book = BookFactory.aBook
		
		let sut = Books(resultCount: 1, results: [book])
		
		XCTAssertEqual(sut.results.count, 1, "result count")
		XCTAssertEqual(sut.results.first!, book, "book")
	}
	
}
