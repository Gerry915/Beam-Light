//
//  HomeViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 11/3/2022.
//

import Foundation

class HomeViewModel {
    
    var bookshelves: [Bookshelf]

    var isEmpty: Bool {
        return bookshelves.isEmpty
    }
    
    init(bookshelves: [Bookshelf]) {
        self.bookshelves = bookshelves
    }
    
    func numberOfItems() -> Int {
        bookshelves.count == 0 ? 1 : bookshelves.count
    }
    
    func getBookshelf(for idx: Int) -> Bookshelf {
        return bookshelves[idx]
    }
}
