//
//  BookshelfListViewModel.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 29/6/2022.
//

import XCTest
@testable import Beam_Light

class BookshelfListViewModel: XCTestCase {

	func test_can_init_instance() {
		let sut = BookshelfListViewModel()
		
		XCTAssertNotNil(sut)
	}

}
