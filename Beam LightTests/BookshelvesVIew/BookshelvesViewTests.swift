//
//  BookshelvesViewTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 4/7/2022.
//

import XCTest
@testable import Beam_Light

class BookshelvesViewTests: XCTestCase {

	func test_can_init_instance() {
		let sut = makeSUT()
		
		XCTAssertNotNil(sut)
	}

	
}

private extension BookshelvesViewTests {
	func makeSUT() -> BookshelvesViewController {
		BookshelvesViewController(viewModel: BookshelvesViewModel(getAllUseCase: MockGetAllBookshelfUseCase(), createBookshelfUseCase: MockCreateBookshelfUseCase(), deleteBookshelfUseCase: MockDeleteBookshelfUseCase(), updateBookshelfUseCase: MockUpdateBookshelfUseCase()))
	}
}
