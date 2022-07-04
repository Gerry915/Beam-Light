//
//  BookshelfCellTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 4/7/2022.
//

import XCTest
@testable import Beam_Light

class BookshelfCellTests: XCTestCase {

	func test_can_init_instance() {
		let sut = BookshelfCell()
		
		XCTAssertNotNil(sut)
	}
	
	func test_can_init_with_coder() throws {
		let object = BookshelfCell()
		
		let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
		
		let coder = try NSKeyedUnarchiver(forReadingFrom: data)
		
		let sut = BookshelfCell(coder: coder)
		
		XCTAssertNil(sut)
	}
	
	func test_configure() {
		let sut = BookshelfCell()
		
		sut.configure(title: "test", bookCount: 1)
		
		let config = sut.contentConfiguration as? UIListContentConfiguration
		
		XCTAssertEqual(sut.accessoryType, .disclosureIndicator)
		
		XCTAssertEqual(config?.text, "test")
		XCTAssertEqual(config?.secondaryText, "1 books")
	}

}
