//
//  BookshelfListViewModelTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 5/7/2022.
//

import XCTest
@testable import Beam_Light

class BookshelfListViewModelTests: XCTestCase {

	func test_can_init_instance() {
		let sut = makeSUT()
		
		XCTAssertNotNil(sut)
		XCTAssertEqual(sut.bookshelves.count, 0)
	}
	
	func test_get_all_bookshelf() async {
		let sut = makeSUT()
		
		await sut.getAllBookshelf()
		
		XCTAssertNotEqual(sut.bookshelves.count, 0)
		
	}
	
	func test_get_bookshelf() async {
		let sut = makeSUT()
		
		await sut.getAllBookshelf()
		
		let bookshelf = sut.getBookshelf(for: 0)
		
		XCTAssertNotNil(bookshelf)
	}
	
	func test_update_bookshelf() async {
		let sut = makeSUT()
		
		await sut.getAllBookshelf()
		
		var bookshelf = sut.getBookshelf(for: 0)
		
		bookshelf.title = "changed"
		
		await sut.updateBookshelf(bookshelf)
		
		XCTAssertNotNil(sut.bookshelves[0])
	}
	
	private func makeSUT() -> BookshelfListViewModel {
		BookshelfListViewModel(getAllBookshelfUseCase: MockGetAllBookshelfUseCase(), updateBookshelfUseCase: MockUpdateBookshelfUseCase())
	}

}
