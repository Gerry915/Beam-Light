//
//  BookHeaderTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 4/7/2022.
//

import XCTest
@testable import Beam_Light

class BookHeaderTests: XCTestCase {
	
	let imageURL = "https://i.picsum.photos/id/735/200/300.jpg?hmac=1a236E3f0SNOHOLEh3dxu5_WIFvWaNKYBSZXBWpi6xE"

	func test_can_init_instance() {
		let sut = BookHeader()
		
		XCTAssertNotNil(sut)
	}
	
	func test_can_init_with_coder() throws {
		let object = BookHeader()
		
		let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
		
		let coder = try NSKeyedUnarchiver(forReadingFrom: data)
		
		let sut = BookHeader(coder: coder)
		
		XCTAssertNotNil(sut)
	}
	
	func test_can_layout_subviews() {
		let sut = BookHeader()
		
		sut.layoutIfNeeded()
		
		XCTAssertEqual(sut.bookCoverImageView.frame.width, 200)
		XCTAssertEqual(sut.bookCoverImageView.frame.height, 300)
		XCTAssertEqual(sut.bookCoverImageView.center, sut.center)
		XCTAssertEqual(sut.loadingView.center, sut.center)
	}
	
	func test_prepare_for_reuse() {
		let sut = BookHeader()
		
		sut.prepareForReuse()
		
		XCTAssertNil(sut.bookCoverImageView.image)
		XCTAssertTrue(sut.loadingView.isAnimating)
	}
	
	func test_load_image() {
		let sut = BookHeader()
		
		sut.configure(coverImage: imageURL)
		
		wait(for: 0.2)
		
		XCTAssertNotNil(sut.bookCoverImageView.image, "SD image loading")
		XCTAssertFalse(sut.loadingView.isAnimating, "loading view stop animating")
	}

	private func wait(for time: TimeInterval) {
		let delayExpectation = XCTestExpectation()
		delayExpectation.isInverted = true
		wait(for: [delayExpectation], timeout: time)
	}
}
