//
//  EmptyBookshelfCellTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 3/7/2022.
//

import XCTest
@testable import Beam_Light

class EmptyBookshelfCellTests: XCTestCase {

	func test_can_init_instance() {
		let sut = EmptyBookshelvesCell()
		
		XCTAssertNotNil(sut)
	}
	
	func test_render_emptyLabel_text() {
		let sut = EmptyBookshelvesCell()
		
		XCTAssertEqual(sut.emptyLabel.text, "You have no bookshelves", "EmptyLabel")
	}
	
	func test_render_createButton_text() {
		let sut = EmptyBookshelvesCell()
		
		XCTAssertEqual(sut.createButton.titleLabel?.text, "Create", "CreateButton")
	}
	
	func test_createButton_action() {
		let sut = EmptyBookshelvesCell()
		
		var touchCount: Int = 0
		
		sut.handleCreateButtonTap = {
			touchCount += 1
		}
		
		sut.createButton.sendActions(for: .touchUpInside)
		
		XCTAssertEqual(touchCount, 1)
	}

}
