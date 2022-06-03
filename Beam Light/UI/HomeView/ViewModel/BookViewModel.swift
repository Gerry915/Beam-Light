//
//  BookViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 21/3/2022.
//

import Foundation

class BookViewModel {
    
    private(set) var book: Book
    
    var loader: StorageService
    
    init(book: Book, loader: StorageService) {
        self.book = book
        self.loader = loader
    }
    
    var title: String {
        book.trackName
    }
    
    var coverSmall: String {
        book.coverSmall
    }
    
    var coverLarge: String {
        book.coverLarge
    }
    
    var author: String {
        book.artistName
    }
    
    var content: String {
        book.bookDescription
    }
    
    var ratingCount: Int? {
        book.userRatingCount
    }
    
    var averageRating: Double? {
        book.averageUserRating ?? 0
    }
    
    func saveToBookshelf() {
        print("TODO")
    }
}

extension BookViewModel: SearchResultPresentable {}
