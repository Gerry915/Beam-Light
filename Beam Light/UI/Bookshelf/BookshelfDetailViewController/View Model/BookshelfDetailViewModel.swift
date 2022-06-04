//
//  BookshelfDetailViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 14/3/2022.
//

import Foundation

class BookshelfDetailViewModel {
	
    var bookshelf: Bookshelf
    
	init(bookshelf: Bookshelf) {
        self.bookshelf = bookshelf
    }
    
    var numberOfItems: Int {
        return bookshelf.books.count
    }
    
    func getBook(for idx: Int) -> Book? {
        return bookshelf.books[idx]
    }
    
}
