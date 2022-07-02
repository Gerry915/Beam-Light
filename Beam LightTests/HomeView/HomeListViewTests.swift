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
		
		wait(for: 0.1)
		
		XCTAssertEqual(sut.emptyView.superview, sut.collectionView)
	}
	
	func test_empty_view_is_removed() {
		
		let sut = makeSUT()
		
		sut.loadViewIfNeeded()
		
		XCTAssertEqual(sut.emptyView.superview, nil)
	}
	
	func test_bookshelf_cell_render_count() {
		let sut = makeSUT()
		
		sut.loadViewIfNeeded()
		
		wait(for: 0.1)
		
		XCTAssertEqual(sut.numberOfCell, 2, "number of cell in section 0")
	}
	
	func test_empty_view_render_cell() {
		
		let sut = makeSUT()
		
		sut.loadViewIfNeeded()
		
		wait(for: 0.1)
		
		let cell = sut.cell(at: 0) as? BookshelfCollectionViewCell
		
		XCTAssertNotNil(cell, "BookshelfCollectionViewCell")
		XCTAssertNotNil(cell?.showBookDetailViewHandler, "showBookDetailViewHandler")
		XCTAssertNotNil(cell?.showBookshelfDetailHandler, "showBookshelfDetailHandler")
		XCTAssertNotNil(cell?.viewModel)
		
	}
	
	func test_empty_view_render_cell_with_correct_content() {
		
		let sut = makeSUT()
		
		sut.loadViewIfNeeded()
		
		wait(for: 0.1)
		
		let cell = sut.cell(at: 0) as? BookshelfCollectionViewCell
		let cell2 = sut.cell(at: 1) as? BookshelfCollectionViewCell
		
		XCTAssertEqual(cell?.titleLabel.text, "test1")
		XCTAssertEqual(cell2?.titleLabel.text, "test2")
		
	}
	
	private func wait(for time: TimeInterval) {
		let delayExpectation = XCTestExpectation()
		delayExpectation.isInverted = true
		wait(for: [delayExpectation], timeout: time)
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

private extension HomeListView {
	
	var bookshelfSection: Int { 0 }
	
	var dataSource: UICollectionViewDataSource? {
		self.collectionView.dataSource
	}
	
	var numberOfCell: Int? {
		dataSource?.collectionView(self.collectionView, numberOfItemsInSection: bookshelfSection)
	}
	
	func cell(at row: Int) -> UICollectionViewCell? {
		
		return dataSource?.collectionView(self.collectionView, cellForItemAt: IndexPath(row: row, section: bookshelfSection))
	}
}
