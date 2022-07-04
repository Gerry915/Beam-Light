//
//  BookshelfDetailViewModelTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 4/7/2022.
//

import XCTest
@testable import Beam_Light

class BookshelfDetailViewModelTests: XCTestCase {

	func test_can_init_instance() {
		let sut = BookshelfDetailViewModel(bookshelf: Bookshelf(id: UUID(), title: "test", books: [], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertNotNil(sut)
	}
	
	func test_numberOfItems_is_zero() {
		let sut = BookshelfDetailViewModel(bookshelf: Bookshelf(id: UUID(), title: "test", books: [], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertEqual(sut.numberOfItems, 0, "number of lines")
	}
	
	func test_numberOfItems_is_one() {
		let sut = BookshelfDetailViewModel(bookshelf: Bookshelf(id: UUID(), title: "test", books: [BookFactory.aBook], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertEqual(sut.numberOfItems, 1, "number of lines")
	}
	
	func test_get_a_book() {
		let sut = BookshelfDetailViewModel(bookshelf: Bookshelf(id: UUID(), title: "test", books: [BookFactory.aBook], createAt: Date(), modifiedAt: Date()))
		
		let book = sut.getBook(for: 0)
		
		XCTAssertNotNil(book)
		XCTAssertEqual(book?.bookDescription, "test")
	}

}
