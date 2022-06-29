//
//  BookViewModelTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 28/6/2022.
//

import XCTest
@testable import Beam_Light

class BookViewModelTests: XCTestCase {
	
	var book: Book!
	
	override func setUpWithError() throws {
		book = BookFactory.aBook
	}

	func test_can_init_instance() {
		let sut = BookViewModel(book: book)
		
		XCTAssertEqual(sut.book.artistName, book.artistName)
	}
	
	func test_title() {
		let sut = BookViewModel(book: book)
		
		XCTAssertEqual(sut.title, book.trackName)
	}
	
	func test_coverSmall() {
		let sut = BookViewModel(book: book)
		
		XCTAssertEqual(sut.coverSmall, book.coverSmall)
	}
	
	func test_coverLarge() {
		let sut = BookViewModel(book: book)
		
		XCTAssertEqual(sut.coverLarge, book.coverLarge)
	}
	
	func test_author() {
		let sut = BookViewModel(book: book)
		
		XCTAssertEqual(sut.author, book.artistName)
	}
	
	func test_content() {
		let sut = BookViewModel(book: book)
		
		XCTAssertEqual(sut.content, book.bookDescription)
	}
	
	func test_ratingCount() {
		let sut = BookViewModel(book: book)
		
		XCTAssertEqual(sut.ratingCount, book.userRatingCount)
	}
	
	func test_averageRating() {
		let sut = BookViewModel(book: book)
		
		XCTAssertEqual(sut.averageRating, book.averageUserRating)
	}
	
	func test_averageRating_should_return_zero() {
		let sut = BookViewModel(book: .init(fileSizeBytes: nil, formattedPrice: nil, trackCensoredName: nil, artistViewURL: "test", trackViewURL: "test", artworkUrl60: "test", artworkUrl100: "test", releaseDate: "test", trackName: "test", currency: "test", bookDescription: "test", artistID: 1, artistName: "test", price: nil, averageUserRating: nil, userRatingCount: nil))
		
		XCTAssertEqual(sut.averageRating, 0)
	}

}
