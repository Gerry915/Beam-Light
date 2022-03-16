//
//  BookshelfViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import Foundation

struct BookshelfViewModel {
    
    var model: [Bookshelf]
    
    var bookshelfCount: Int {
        return model.count
    }
    
    func getBookshelf(for idx: Int) -> Bookshelf {
        return model[idx]
    }
    
    mutating func removeShelf(for idx: Int) {
        model.remove(at: idx)
    }
}
