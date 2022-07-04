//
//  BookshelfFooterTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 4/7/2022.
//

import XCTest
@testable import Beam_Light

class BookshelfFooterTests: XCTestCase {

	func test_can_init_instance() {
		let sut = BookshelfFooter()
		
		XCTAssertNotNil(sut)
	}
	
	func test_init_with_coder() throws {
		let object = BookshelfFooter()
	
		let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
		let coder = try NSKeyedUnarchiver(forReadingFrom: data)
		let sut = BookshelfFooter(coder: coder)
		XCTAssertNotNil(sut)
	}
	
	func test_commonInt_added_button() {
		let sut = BookshelfFooter()
		
		XCTAssertEqual(sut.actionButton.superview, sut.contentView)
	}
	
	func test_closure_been_called() {
		let sut = BookshelfFooter()
		
		var counter = 0
		
		sut.handleButtonTap = {
			counter += 1
		}
		
		sut.actionButton.sendActions(for: .touchUpInside)
		
		XCTAssertEqual(counter, 1)
	}

}
