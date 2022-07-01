//
//  HomeListViewTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 1/7/2022.
//

import XCTest
@testable import Beam_Light

class HomeListViewTests: XCTestCase {

	func test_can_init_instance() {
		let sut = makeSUT()
		
		XCTAssertNotNil(sut)
	}
	
	func test_initial_view_state() {
		let sut = makeSUT()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.view.backgroundColor, .systemBackground)
		XCTAssertEqual(sut.collectionView.backgroundColor, .clear)
		XCTAssertEqual(sut.view.alpha, 0)
	}
	
	func test_initial_has_empty_view() {
		
		let sut = HomeListView(viewModel: BookshelvesViewModel(getAllUseCase: EmptyGetAllUseCaseSpy(), createBookshelfUseCase: MockCreateBookshelfUseCase(), deleteBookshelfUseCase: MockDeleteBookshelfUseCase(), updateBookshelfUseCase: MockUpdateBookshelfUseCase()), layout: UICollectionViewLayout())
		
		sut.loadViewIfNeeded()
		
		let delayExpectation = XCTestExpectation()
		delayExpectation.isInverted = true
		wait(for: [delayExpectation], timeout: 0.1)
		
		XCTAssertEqual(sut.emptyView.superview, sut.collectionView)
	}
	
	func test_empty_view_is_removed() {
		
		let sut = makeSUT()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.emptyView.superview, nil)
	}
	
	func test_empty_view_render_cell() {
		
		let sut = makeSUT()
		
		sut.loadViewIfNeeded()
		
		let delayExpectation = XCTestExpectation()
		delayExpectation.isInverted = true
		wait(for: [delayExpectation], timeout: 0.1)
		
		let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? BookshelfCollectionViewCell
		
		XCTAssertNotNil(cell, "BookshelfCollectionViewCell")
		XCTAssertNotNil(cell?.showBookDetailViewHandler, "showBookDetailViewHandler")
		XCTAssertNotNil(cell?.showBookshelfDetailHandler, "showBookshelfDetailHandler")
		
	}

	
	private func makeSUT() -> HomeListView {
		HomeListView(viewModel: BookshelvesViewModel(
			getAllUseCase: MockGetAllBookshelfUseCase(),
			createBookshelfUseCase: MockCreateBookshelfUseCase(),
			deleteBookshelfUseCase: MockDeleteBookshelfUseCase(),
			updateBookshelfUseCase: MockUpdateBookshelfUseCase()),
					 layout: UICollectionViewLayout()
		)
	}
	
	private class EmptyGetAllUseCaseSpy: GetAllBookshelfUseCaseProtocol {
		func execute() async -> Result<[Bookshelf], CustomStorageError> {
			.success([])
		}
	}
}
