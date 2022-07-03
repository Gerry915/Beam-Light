//
//  BookshelfCollectionViewCellTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 3/7/2022.
//

import XCTest
@testable import Beam_Light

class BookshelfCollectionViewCellTests: XCTestCase {

	func test_can_init_instance() {
		let sut = BookshelfCollectionViewCell()
		
		XCTAssertNotNil(sut)
	}
	
	func test_prepareForReuse() {
		let sut = BookshelfCollectionViewCell()
		sut.prepareForReuse()
		
		XCTAssertFalse(sut.emptyBookMessage.isHidden)
	}
	
	func test_collectionView_setup() {
		let sut = BookshelfCollectionViewCell()
		
		XCTAssertNotNil(sut.collectionView.delegate, "delegate")
		XCTAssertNotNil(sut.collectionView.dataSource, "dataSource")
	}
	
	func test_emptyBookMessageLabel_with_empty_book() {
		let sut = BookshelfCollectionViewCell()
		
		sut.viewModel = BookshelfViewModel(updateBookshelfUseCase: MockUpdateBookshelfUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertFalse(sut.emptyBookMessage.isHidden)
	}
	
	func test_emptyBookMessageLabel_with_one_book() {
		let sut = BookshelfCollectionViewCell()
		
		sut.viewModel = BookshelfViewModel(updateBookshelfUseCase: MockUpdateBookshelfUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [BookFactory.aBook], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertTrue(sut.emptyBookMessage.isHidden)
	}
	
	func test_collectionView_initial_line_count() {
		let sut = BookshelfCollectionViewCell()
		
		XCTAssertEqual(sut.collectionView.numberOfItems(), 0)
	}
	
	func test_collectionView_with_one_book() {
		let sut = BookshelfCollectionViewCell()
		
		sut.viewModel = BookshelfViewModel(updateBookshelfUseCase: MockUpdateBookshelfUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [BookFactory.aBook], createAt: Date(), modifiedAt: Date()))
		
		XCTAssertEqual(sut.collectionView.numberOfItems(), 1)
	}
	
	func test_collectionView_render_cell() {
		let sut = BookshelfCollectionViewCell()
		
		sut.viewModel = BookshelfViewModel(updateBookshelfUseCase: MockUpdateBookshelfUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [BookFactory.aBook], createAt: Date(), modifiedAt: Date()))
		
		let cell = sut.collectionView.cell(at: 0)
		
		XCTAssertNotNil(cell as? BookCoverCell)
	}
	
	func test_showBookshelfDetailHandler_wont_fire_without_viewModel() {
		let sut = BookshelfCollectionViewCell()
		
		var called = false
		
		sut.showBookshelfDetailHandler = { _ in
			called = true
		}
		
		sut.seeAllButton.sendActions(for: .touchUpInside)
		
		XCTAssertFalse(called)
	}
	
	func test_showBookshelfDetailHandler_got_called() {
		let sut = BookshelfCollectionViewCell()
		
		sut.viewModel = BookshelfViewModel(updateBookshelfUseCase: MockUpdateBookshelfUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [BookFactory.aBook], createAt: Date(), modifiedAt: Date()))
		
		var called = false
		
		sut.showBookshelfDetailHandler = { _ in
			called = true
		}
		
		sut.seeAllButton.sendActions(for: .touchUpInside)
		
		XCTAssertTrue(called)
	}
	
	func test_showBookDetailViewHandler_got_called() {
		let sut = BookshelfCollectionViewCell()
		
		sut.viewModel = BookshelfViewModel(updateBookshelfUseCase: MockUpdateBookshelfUseCase(), bookshelf: Bookshelf(id: UUID(), title: "test", books: [BookFactory.aBook], createAt: Date(), modifiedAt: Date()))
		
		var called = false
		
		sut.showBookDetailViewHandler = { _ in
			called = true
		}
		
		let cell = sut.collectionView.cell(at: 0) as? BookCoverCell
		
		cell?.didTapBook!()
		
		XCTAssertTrue(called)
	}

}

private extension UICollectionView {
	
	var bookSection: Int { 0 }
	
	func numberOfItems() -> Int? {
		dataSource?.collectionView(self, numberOfItemsInSection: bookSection)
	}
	
	func cell(at row: Int) -> UICollectionViewCell? {
		dataSource?.collectionView(self, cellForItemAt: IndexPath(row: row, section: bookSection))
	}
	
}
