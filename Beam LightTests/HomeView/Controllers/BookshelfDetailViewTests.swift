//
//  BookshelfDetailViewTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 4/7/2022.
//

import XCTest
@testable import Beam_Light

class BookshelfDetailViewTests: XCTestCase {

	func test_can_init_instance() {
		let sut = makeSUT()
		
		XCTAssertNotNil(sut)
	}
	
	func test_init_with_coder_return_nil() throws {
		let object = makeSUT()
		
		let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
		
		let coder = try NSKeyedUnarchiver(forReadingFrom: data)
		
		let sut = BookshelfDetailViewController(coder: coder)
		
		XCTAssertNil(sut)
	}

	
	private func makeSUT() -> BookshelfDetailViewController {
		BookshelfDetailViewController(style: .plain, viewModel: BookshelfViewModel(updateBookshelfUseCase: MockUpdateBookshelfUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [], createAt: Date(), modifiedAt: Date())))
	}
}
