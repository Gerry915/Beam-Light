//
//  BookDetailViewTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 2/7/2022.
//

import XCTest
@testable import Beam_Light

class BookDetailViewTests: XCTestCase {

	func test_can_init_instance() {
		let sut = BookDetailViewController(bookViewModel: BookViewModel(book: BookFactory.aBook))
		
		XCTAssertNotNil(sut)
	}
	
	func test_can_init_instance_with_no_tool_bar() {
		let sut = BookDetailViewController(bookViewModel: BookViewModel(book: BookFactory.aBook), displayToolBar: false)
		
		sut.loadViewIfNeeded()
		
		XCTAssertNil(sut.navigationItem.rightBarButtonItem, "right bar item")
	}
	
	func test_can_init_instance_with_tool_bar() {
		let sut = BookDetailViewController(bookViewModel: BookViewModel(book: BookFactory.aBook), displayToolBar: true)
		
		sut.loadViewIfNeeded()
		
		XCTAssertNotNil(sut.navigationItem.rightBarButtonItem, "right bar item")
	}

}
