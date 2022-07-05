//
//  PaddingTextFieldTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 4/7/2022.
//

import XCTest
@testable import Beam_Light

class PaddingTextFieldTests: XCTestCase {
	
	var testBounds: CGRect!
	
	override func setUpWithError() throws {
		testBounds = .init(x: 0, y: 0, width: 200, height: 200)
	}

	func test_can_init_instance() {
		let sut = PaddingTextField()
		
		XCTAssertNotNil(sut)
	}
	
	func test_with_correct_placeholder_padding_setup() {
		let sut = PaddingTextField()
		
		let bounds = sut.placeholderRect(forBounds: testBounds)
		
		XCTAssertEqual(bounds.width, 164)
		XCTAssertEqual(bounds.height, 184)
	}
	
	func test_with_correct_text_rect_setup() {
		let sut = PaddingTextField()
		
		let bounds = sut.textRect(forBounds: testBounds)
		
		XCTAssertEqual(bounds.width, 164)
		XCTAssertEqual(bounds.height, 184)
	}
	
	func test_with_correct_editing_rect_setup() {
		let sut = PaddingTextField()
		
		let bounds = sut.editingRect(forBounds: testBounds)
		
		XCTAssertEqual(bounds.width, 164)
		XCTAssertEqual(bounds.height, 184)
	}
	
	func test_set_underline() {
		let sut = PaddingTextField()
		
		sut.setUnderLine()
		
		XCTAssertEqual(sut.layer.sublayers?.count, 2)
		XCTAssertTrue(sut.layer.masksToBounds)
	}

}
