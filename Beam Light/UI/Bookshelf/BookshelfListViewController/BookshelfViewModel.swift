//
//  BookshelfViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import Foundation

class BookshelfViewModel {
	
	private let updateBookshelfUseCase: UpdateBookshelfUseCaseProtocol
    
    private(set) var bookshelf: Bookshelf
	
	private(set) var previewCountNumber: Int = 5

	init(updateBookshelfUseCase: UpdateBookshelfUseCaseProtocol, bookshelf: Bookshelf) {
		self.updateBookshelfUseCase = updateBookshelfUseCase
		self.bookshelf = bookshelf
	}
    
    var bookCount: Int {
        bookshelf.books.count
    }
	
	var previewCount: Int {
		bookshelf.books.count > previewCountNumber ? previewCountNumber : bookshelf.books.count
	}
    
    var title: String {
        bookshelf.title
    }
    
    var id: String {
        bookshelf.id.uuidString
    }
    
    func generate(for idx: Int) -> Book {
        return bookshelf.books[idx]
    }
    
    func removeBook(at idx: Int) {
        bookshelf.books.remove(at: idx)
    }
}
