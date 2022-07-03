//
//  HomeContainerViewTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 1/7/2022.
//

import XCTest
@testable import Beam_Light

class HomeContainerViewTests: XCTestCase {

	func test_can_init_instance() {
		let sut = HomeViewContainerView()
		
		XCTAssertNotNil(sut, "HomeViewContainerView")
	}
	
	func test_cannot_setup_ui_with_nil_header_view() {
		let sut = HomeViewContainerView()
		sut.headerView = UIViewController()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.headerView?.parent, nil)
	}
	
	func test_cannot_setup_ui_with_nil_list_view() {
		let sut = HomeViewContainerView()
		sut.listView = UIViewController()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.listView?.parent, nil)
	}
	
	func test_added_header_and_list_view() {
		let sut = HomeViewContainerView()
		sut.headerView = UIViewController()
		sut.listView = UIViewController()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.headerView?.parent, sut)
		XCTAssertEqual(sut.listView?.parent, sut)
	}

}
