//
//  BookModelTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 28/6/2022.
//

import XCTest
@testable import Beam_Light

class BookModelTests: XCTestCase {
	
	var mockArtworkUrl100 = "https://is1-ssl.mzstatic.com/image/thumb/Publication114/v4/89/9c/22/899c22be-96d9-6841-0779-21c8046db455/9781094372662.jpg/100x100bb.jpg"
	
	func test_can_init_instance_with_correct_optional_values() {
		let sut = makeSUT()
		
		XCTAssertEqual(sut.fileSizeBytes!, 100, "fileSizeBytes")
		XCTAssertEqual(sut.formattedPrice!, "formattedPrice", "formattedPrice")
		XCTAssertEqual(sut.price!, 1.00, "price")
		XCTAssertEqual(sut.averageUserRating!, 5.00, "averageUserRating")
		XCTAssertEqual(sut.userRatingCount!, 1, "userRatingCount")
		

		XCTAssertNotNil(sut, "init")
	}
	
	func test_processCoverUrl_return_empty_string() {
		let sut = Book.processCoverUrl(url: nil, size: 200)
		
		XCTAssertEqual(sut, "", "book model - process cover url")
	}
	
	func test_processCoverUrl_coverSmall() {
		let sut = Book.processCoverUrl(url: mockArtworkUrl100, size: 200)
		
		XCTAssertEqual(sut, "https://is1-ssl.mzstatic.com/image/thumb/Publication114/v4/89/9c/22/899c22be-96d9-6841-0779-21c8046db455/9781094372662.jpg/1200x200.jpg", "processCoverURL")
	}
	
	func test_get_coverSmall_return_right_string() {
		let sut = makeSUT()
		
		XCTAssertEqual(sut.coverSmall, "https://is1-ssl.mzstatic.com/image/thumb/Publication114/v4/89/9c/22/899c22be-96d9-6841-0779-21c8046db455/9781094372662.jpg/1200x200.jpg", "coverSmall")
	}
	
	func test_get_coverLarge_return_right_string() {
		let sut = makeSUT()
		
		XCTAssertEqual(sut.coverLarge, "https://is1-ssl.mzstatic.com/image/thumb/Publication114/v4/89/9c/22/899c22be-96d9-6841-0779-21c8046db455/9781094372662.jpg/1900x900.jpg", "coverLarge")
	}

	
	private func makeSUT() -> Book {
		Book(fileSizeBytes: 100, formattedPrice: "formattedPrice", trackCensoredName: "trackCensoredName", artistViewURL: "url", trackViewURL: "url", artworkUrl60: "url", artworkUrl100: mockArtworkUrl100, releaseDate: "date", trackName: "name", currency: "currency", bookDescription: "test", artistID: 1, artistName: "test", price: 1.00, averageUserRating: 5.00, userRatingCount: 1)
	}
}
