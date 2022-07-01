//
//  HomeSearchViewTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 1/7/2022.
//

import XCTest
@testable import Beam_Light

class HomeSearchViewTests: XCTestCase {

	func test_can_init_instance() {
		let sut = HomeSearchView()
		
		XCTAssertNotNil(sut)
	}
	
	func test_added_search_bar() {
		let sut = HomeSearchView()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.searchBar.superview, sut.view)
	}
	
	func test_setup_search_bar() {
		let sut = HomeSearchView()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.searchBar.searchBarStyle, .minimal, "search bar style")
		XCTAssertEqual(sut.searchBar.placeholder, "Search your next book...", "search bar style")
	}
	
	func test_setup_search_bar_delegate() {
		let sut = HomeSearchView()
		
		sut.loadViewIfNeeded()
		
		XCTAssertNotNil(sut.searchBar.delegate, "Search bar delegate")
	}
	
	func test_search_delegate_callback() {
		let sut = HomeSearchView()
		
		sut.handleSearch = { value in
			XCTAssertEqual(sut.searchBar.text, "Hello")
		}
		
		sut.loadViewIfNeeded()
		
		sut.searchBar.text = "Hello"
		sut.searchBarSearchButtonClicked(sut.searchBar)
		
	}
	
	func test_search_delegate_callback_not_send_with_empty_value() {
		let sut = HomeSearchView()
		
		sut.handleSearch = { value in
			XCTFail()
		}
		
		sut.loadViewIfNeeded()
		
		sut.searchBar.text = " "
		sut.searchBarSearchButtonClicked(sut.searchBar)
		
	}
	
	
}

