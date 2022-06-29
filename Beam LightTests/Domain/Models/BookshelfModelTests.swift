//
//  BookshelfModelTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 28/6/2022.
//

import XCTest
@testable import Beam_Light

class BookshelfModelTests: XCTestCase {

	func test_can_init_instance() {
		let sut = Bookshelf(id: UUID(), title: "test", books: [], createAt: Date(), modifiedAt: Date())
		
		XCTAssertNotNil(sut, "init")
	}
	
	func test_can_init_instance_with_book() {
		let book = BookFactory.aBook
		let sut = Bookshelf(id: UUID(), title: "test", books: [book], createAt: Date(), modifiedAt: Date())
		
		XCTAssertEqual(sut.books.first!, book, "book")
	}

}
