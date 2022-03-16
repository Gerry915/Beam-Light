//
//  SearchResultViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/3/2022.
//

import UIKit

class SearchResultViewModel {
    
    var model: Books
    
    init(model: Books) {
        self.model = model
    }
    
    var resultCount: Int {
        return model.resultCount
    }
    
    func getBookForIndex(index: Int) -> Book {
        return model.results[index]
    }
}
