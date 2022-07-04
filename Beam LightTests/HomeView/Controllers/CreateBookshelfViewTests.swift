//
//  CreateBookshelfViewTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 4/7/2022.
//

import XCTest
@testable import Beam_Light

class CreateBookshelfViewTests: XCTestCase {

	func test_can_init_instance() {
		let sut = CreateBookshelfViewController()
		
		XCTAssertNotNil(sut)
	}
	
	func test_render_heading_label() {
		let sut = CreateBookshelfViewController()
		
		XCTAssertEqual(sut.headingLabel.text, "What would you like to name your bookshelf?", "Heading Label Text")
	}
	
	func test_render_create_button_title() {
		let sut = CreateBookshelfViewController()
		
		XCTAssertEqual(sut.createButton.titleLabel?.text, "Create", "Create button title")
	}
	
	func test_input_field_placeholder_text() {
		let sut = CreateBookshelfViewController()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.inputTextView.placeholder, "Bookshelf name", "Input field placeholder text")
	}
	
	func test_input_field_delegate() {
		let sut = CreateBookshelfViewController()
		
		sut.loadViewIfNeeded()
		
		XCTAssertNotNil(sut.inputTextView.delegate)
	}
	
	func test_create_button_did_tap() {
		let sut = CreateBookshelfViewController()
		
		sut.loadViewIfNeeded()
		
		sut.bookshelfName = "test"
		
		sut.didCreateBookshelf = { value in
			XCTAssertEqual(value, "test", "Bookshelf name")
		}
		
		sut.createButton.sendActions(for: .touchUpInside)
	}
	
	func test_cannot_create_with_empty_string() {
		let sut = CreateBookshelfViewController()
		
		sut.loadViewIfNeeded()
		
		sut.bookshelfName = ""
		
		var counter = 0
		
		sut.didCreateBookshelf = { value in
			counter += 1
		}
		
		sut.createButton.sendActions(for: .touchUpInside)
		
		XCTAssertEqual(counter, 0)
	}
	
	func test_view_dismissed_after_creatation() {
		let sut = CreateBookshelfViewControllerSpy()
		
		sut.loadViewIfNeeded()
		
		sut.bookshelfName = "test"
		
		sut.createButton.sendActions(for: .touchUpInside)
		
		XCTAssertTrue(sut.viewIsGone)
	}
	
	func test_input_field() {
		let sut = CreateBookshelfViewController()
		
		sut.loadViewIfNeeded()
		
		sut.inputTextView.text = "test"
		
		sut.inputTextView.delegate?.textFieldDidChangeSelection?(sut.inputTextView)
		
		XCTAssertEqual(sut.bookshelfName, "test", "Input text")
	}
	
	private class CreateBookshelfViewControllerSpy: CreateBookshelfViewController {
		
		var viewIsGone: Bool = false
		
		override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
			viewIsGone = true
		}
		
	}

}


