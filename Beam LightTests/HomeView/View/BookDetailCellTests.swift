//
//  BookDetailCellTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 4/7/2022.
//

import XCTest
@testable import Beam_Light

class BookDetailCellTests: XCTestCase {

	func test_can_init_instance() {
		let sut = BookDetailCell()
		
		XCTAssertNotNil(sut)
	}
	
	func test_init_with_coder() throws {
		let object = BookDetailCell()
	
		let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
		let coder = try NSKeyedUnarchiver(forReadingFrom: data)
		let sut = BookDetailCell(coder: coder)
		XCTAssertNotNil(sut)
	}
	
	func test_setup_cell() {
		let sut = BookDetailCell()
		
		XCTAssertNotEqual(sut.contentView.subviews.count, 0)
	}
	
	func test_configure_cell_with_presentable() {
		let sut = BookDetailCell()
		
		sut.configure(presentable: MockPresentalbe())
		
		XCTAssertEqual(sut.titleLabel.text, "test")
		XCTAssertEqual(sut.authorLabel.text, "test")
		XCTAssertEqual(sut.descriptionLabel.text, "test")
		
	}
	
	private class MockPresentalbe: SearchResultPresentable {
		var title: String { "test" }
		
		var author: String { "test" }
		
		var content: String { "test" }
		
		var coverSmall: String { "test" }
		
		var coverLarge: String { "test" }
		
		var ratingCount: Int? { 0 }
		
		var averageRating: Double? { 1.0 }

	}

}
