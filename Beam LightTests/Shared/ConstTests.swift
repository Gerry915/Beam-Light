//
//  ConstTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 4/7/2022.
//

import XCTest
@testable import Beam_Light

class ConstTests: XCTestCase {

	func test_iTunes_base_string() {
		let sut = CONSTANT.ENDPOINT.iTunesBase
		
		XCTAssertEqual(sut, "itunes.apple.com")
	}

}
