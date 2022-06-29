//
//  BookshelfViewModelTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 29/6/2022.
//

import XCTest
@testable import Beam_Light

class BookshelfViewModelTests: XCTestCase {

	func test_can_init_instance() {
		let sut = BookshelfViewModel(updateBookshelfUseCase: MockUpdateUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertNotNil(sut)
	}
	
	func test_book_count_zero() {
		let sut = BookshelfViewModel(updateBookshelfUseCase: MockUpdateUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertEqual(sut.bookCount, 0)
	}
	
	func test_book_count_one() {
		let sut = BookshelfViewModel(updateBookshelfUseCase: MockUpdateUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [BookFactory.aBook], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertEqual(sut.bookCount, 1)
	}
	
	func test_bookshelf_title() {
		let sut = BookshelfViewModel(updateBookshelfUseCase: MockUpdateUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [BookFactory.aBook], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertEqual(sut.title, "test")
	}
	
	func test_bookshelf_id() {
		let id = UUID()
		let sut = BookshelfViewModel(updateBookshelfUseCase: MockUpdateUseCase(), bookshelf: Bookshelf(id: id, title: "test", books: [BookFactory.aBook], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertEqual(sut.id, id.uuidString)
	}
	
	func test_bookshelf_get_book() {
		let book = BookFactory.aBook
		let sut = BookshelfViewModel(updateBookshelfUseCase: MockUpdateUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [book], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertEqual(sut.generate(for: 0), book)
	}
	
	func test_bookshelf_remove_book() {
		let book = BookFactory.aBook
		let sut = BookshelfViewModel(updateBookshelfUseCase: MockUpdateUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [book], createAt: Date(), modifiedAt: Date()))
		
		sut.removeBook(at: 0)
		
		XCTAssertEqual(sut.bookCount, 0)
	}

}

class MockUpdateUseCase: UpdateBookshelfUseCaseProtocol {
	func execute(_ id: String, _ data: Bookshelf) async -> Result<Bool, CustomStorageError> {
		.success(true)
	}
	
	
}
