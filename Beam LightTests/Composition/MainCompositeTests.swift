//
//  MainCompositeTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 1/7/2022.
//

import XCTest
@testable import Beam_Light

class MainCompositeTests: XCTestCase {

	func test_can_init_instance() {
		let sut = makeSUT()
		
		XCTAssertNotNil(sut, "MainComposite")
	}
	
	func test_compose_main_tab_view_controller() {
		let sut = makeSUT()
		
		XCTAssertNotNil(sut.compose() as? MainTabViewController, "MainTabViewController")
	}
	
	func test_compose_right_child_controller() {
		let sut = makeSUT()
		
		let main = sut.compose() as! MainTabViewController
		
		XCTAssertEqual(main.viewControllers?.count, 2)
	}
	
	func test_compose_first_child_controller() {
		let sut = makeSUT()
		
		let main = sut.compose() as! MainTabViewController
		let nav = main.viewControllers?.first! as? UINavigationController
		XCTAssertNotNil(nav, "NavigationController")
		let first = nav?.viewControllers.first! as? HomeViewContainerView
		XCTAssertNotNil(first, "HomeViewContainerView")
		
	}
	
	func test_compose_header_view() {
		let sut = makeFirstView() as? HomeViewContainerView
		
		let headerView = sut?.headerView as? HomeSearchView
		
		XCTAssertNotNil(headerView)
		XCTAssertNotNil(headerView?.handleSearch)
	}
	
	func test_compose_list_view() {
		let sut = makeFirstView() as? HomeViewContainerView
		let listView = sut?.listView as? HomeListView
		
		XCTAssertNotNil(listView)
		XCTAssertNotNil(listView?.createBookshelf)
		XCTAssertNotNil(listView?.presentBookshelf)
		XCTAssertNotNil(listView?.presentBookDetailView)
		
	}
	
	func test_make_bookshelf_view() {
		let sut = makeSUT()
		
		let main = sut.compose() as! MainTabViewController
		let nav = main.viewControllers?.last! as? UINavigationController
		
		XCTAssertNotNil(nav?.viewControllers.first as? BookshelvesViewController)
	}


	
	// MARK: - Helpers
	
	private func makeSUT() -> MainComposite {
		let viewModel = BookshelvesViewModel(getAllUseCase: MockGetAllBookshelfUseCase(), createBookshelfUseCase: MockCreateBookshelfUseCase(), deleteBookshelfUseCase: MockDeleteBookshelfUseCase(), updateBookshelfUseCase: MockUpdateBookshelfUseCase())
		
		return MainComposite(viewModel: viewModel)
	}
	
	private func makeFirstView() -> UIViewController? {
		let sut = makeSUT()
		let main = sut.compose() as! MainTabViewController
		let nav = main.viewControllers?.first as? UINavigationController
		return nav?.viewControllers.first
	}
}
