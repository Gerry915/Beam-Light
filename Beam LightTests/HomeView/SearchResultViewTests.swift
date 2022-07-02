//
//  SearchResultViewTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 2/7/2022.
//

import XCTest
@testable import Beam_Light

class SearchResultViewTests: XCTestCase {

	func test_can_init_instance() {
		let sut = SearchResultViewController(viewModel: BooksViewModel(service: MockProvider(), terms: "test"))
		
		XCTAssertNotNil(sut)
	}
	
	func test_view_did_load_and_set_up() {
		let sut = SearchResultViewController(viewModel: BooksViewModel(service: MockProvider(), terms: "test"))
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.title, "Search Result", "title")
		XCTAssertEqual(sut.view.backgroundColor, .systemBackground, "background color")
		XCTAssertEqual(sut.loadingView.superview, sut.view, "loadingView")
		XCTAssertEqual(sut.tableView.superview, sut.view, "tableView")
		XCTAssertNotNil(sut.tableView.delegate, "delegate")
		XCTAssertNotNil(sut.dataSource, "dataSource")
	}
	
	func test_data_source_creation() {
		let sut = SearchResultViewController(viewModel: BooksViewModel(service: MockProvider(), terms: "test"))
		
		sut.loadViewIfNeeded()
		
		wait(for: 0.1)
		
		let cell = sut.dataSource.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
		
		XCTAssertNotNil(cell as? BookTableViewCell)
		
	}
	
	func test_is_showing_loading_indicator() {
		let sut = SearchResultViewController(viewModel: BooksViewModel(service: MockProvider(), terms: "test"))
		
		sut.loadViewIfNeeded()
		
		XCTAssertTrue(sut.loadingView.isAnimating)
	
	}
	
	func test_is_loading_indicator_removed() {
		let sut = SearchResultViewController(viewModel: BooksViewModel(service: MockProvider(), terms: "test"))
		
		sut.loadViewIfNeeded()
		
		wait(for: 0.1)
		
		XCTAssertFalse(sut.loadingView.isAnimating)
	}
	
	func test_tableView_render_correct_data() {
		let sut = SearchResultViewController(viewModel: BooksViewModel(service: MockProvider(), terms: "test"))

		sut.loadViewIfNeeded()

		wait(for: 0.1)

		let cell = sut.dataSource.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? BookTableViewCell
		
		XCTAssertEqual(cell?.titleLabel.text, "test")
		XCTAssertEqual(cell?.authorLabel.text, "test")
		XCTAssertEqual(cell?.descriptionLabel.text, "test")
	}
	
	func test_present_book_detail_view() {
		let sut = SearchResultViewController(viewModel: BooksViewModel(service: MockProvider(), terms: "test"))
		
		let mockNav = SpyNavigationController(rootViewController: sut)

		sut.loadViewIfNeeded()

		wait(for: 0.1)

		
		sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
		
		XCTAssertNotNil(mockNav.pushedViewController as? BookDetailViewController)
	}
	
	class SpyNavigationController: UINavigationController {
		
		var pushedViewController: UIViewController?
		
		override func pushViewController(_ viewController: UIViewController, animated: Bool) {
			pushedViewController = viewController
			super.pushViewController(viewController, animated: false)
		}
	}

	private class MockProvider: iTunesProviding {
		func getSearchResult(terms: String) async -> Result<Books, NetworkError> {
			.success(Books(resultCount: 1, results: [BookFactory.aBook]))
		}
	}
	
	private func wait(for time: TimeInterval) {
		let delayExpectation = XCTestExpectation()
		delayExpectation.isInverted = true
		wait(for: [delayExpectation], timeout: time)
	}
}
