//
//  BookshelvesViewModelTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 28/6/2022.
//

import XCTest
@testable import Beam_Light

class BookshelvesViewModelTests: XCTestCase {
	
	var mockUpdateProtocol: MockUpdateBookshelfUseCase!
	var mockDeleteProtocol: MockDeleteBookshelfUseCase!
	var mockGetAllProtocol: MockGetAllBookshelfUseCase!
	var mockCreateProtocol: MockCreateBookshelfUseCase!
	
	override func setUpWithError() throws {
		mockUpdateProtocol = MockUpdateBookshelfUseCase()
		mockDeleteProtocol = MockDeleteBookshelfUseCase()
		mockCreateProtocol = MockCreateBookshelfUseCase()
		mockGetAllProtocol = MockGetAllBookshelfUseCase()
	}

	func test_can_init_instance() async {
		let sut = await makeSUT()
		XCTAssertNotNil(sut, "init instance")
	}
	
	func test_get_bookshelf() async {
		let sut = await makeSUT()
		
		let bookshelf = sut.getBookshelf(for: 0)
		
		XCTAssertNotNil(bookshelf, "bookshelf")
	}
	
	func test_get_all_bookshelf() async {
		let sut = await makeSUT()
		XCTAssertEqual(sut.bookshelves.count, 2, "bookshelf count")
	}
	
	func test_get_all_bookshelf_fail() async {
		let sut = await makeSUT()
		mockGetAllProtocol.isSuccess = false
		
		sut.errorMessage = { message in
			XCTAssertEqual(message, "Cannot Get", "Get Error message")
		}
		
		await sut.getAllBookshelf()
	}
	
	func test_create_bookshelf() async {
		let sut = await makeSUT()
		
		await sut.create(with: "test")
		
		XCTAssertTrue(mockCreateProtocol.isCreated, "Create Bookshelf")
	}
	
	func test_create_bookshelf_fail() async {
		let sut = await makeSUT()
		mockCreateProtocol.isSuccess = false
		
		sut.errorMessage = { message in
			XCTAssertEqual(message, "Cannot create", "Create bookshelf fail")
		}
		
		await sut.create(with: "test")
	}
	
	func test_delete_bookshelf() async {
		let sut = await makeSUT()
		
		await sut.deleteBookshelf("test")
		
		XCTAssertTrue(mockDeleteProtocol.isDeleted, "Delete Bookshelf")
	}
	
	func test_update_bookshelf() async {
		let sut = await makeSUT()
		await sut.updateBookshelf(bookshelf: sut.bookshelves.first!)
		XCTAssertTrue(mockUpdateProtocol.isUpdated, "Update Bookshelf")
	}
	
	func test_update_bookshelf_failure() async {
		let sut = await makeSUT()
		mockUpdateProtocol.isSuccess = false
		
		sut.errorMessage = { message in
			XCTAssertEqual(message, "Cannot update")
		}
		
		await sut.updateBookshelf(bookshelf: sut.bookshelves.first!)
	}
	
	func test_batch_delete() async {
		let sut = await makeSUT()
		
		await sut.batchDelete(ids: [0])
		
		XCTAssertTrue(mockDeleteProtocol.isDeleted)
	}
	
	func test_batch_delete_fail() async {
		
		let sut = await makeSUT()
		mockDeleteProtocol.isSuccess = false
		
		sut.errorMessage = { message in
			XCTAssertEqual(message, "Cannot delete", "Batch delete fail")
		}
		
		await sut.batchDelete(ids: [0])
	}
	
	func test_save_bookshelf_order() async {
		
		let sut = await makeSUT()
		
		sut.saveBookshelfOrder(sourceIndex: 0, destinationIndex: 1)
		
		XCTAssertEqual(sut.bookshelves.first!.title, "test2")
	}
	
	private func makeSUT() async -> BookshelvesViewModel {
		let sut = BookshelvesViewModel(getAllUseCase: mockGetAllProtocol,
									   createBookshelfUseCase: mockCreateProtocol,
									   deleteBookshelfUseCase: mockDeleteProtocol,
									   updateBookshelfUseCase: mockUpdateProtocol
		)
		
		await sut.getAllBookshelf()
		
		return sut
	}

}

