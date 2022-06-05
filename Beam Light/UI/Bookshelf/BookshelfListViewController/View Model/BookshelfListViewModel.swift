//
//  BookshelfListViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/6/2022.
//

import Foundation

class BookshelfListViewModel {
	
	private let getAllBookshelfUseCase: GetAllBookshelfUseCaseProtocol
	private let updateBookshelfUseCase: UpdateBookshelfUseCaseProtocol
	
	@Published private(set) var bookshelves: [Bookshelf] = []
	
	init(getAllBookshelfUseCase: GetAllBookshelfUseCaseProtocol,
		 updateBookshelfUseCase: UpdateBookshelfUseCaseProtocol
	) {
		self.getAllBookshelfUseCase = getAllBookshelfUseCase
		self.updateBookshelfUseCase = updateBookshelfUseCase
	}
	
	func getBookshelf(for idx: Int) -> Bookshelf {
		return bookshelves[idx]
	}
	
	func getAllBookshelf() async {
		let result = await getAllBookshelfUseCase.execute()
		
		if case let .success(result) = result {
			self.bookshelves = result
		}
	}
	
	func updateBookshelf(_ bookshelf: Bookshelf) async {
		let result = await updateBookshelfUseCase.execute(bookshelf.id.uuidString, bookshelf)
		
		if case .success(_) = result {
			await getAllBookshelf()
		}
	}
	
}
