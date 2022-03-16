//
//  Bookshelf.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import Foundation

struct Bookshelf: Codable {
    let id: UUID
    var title: String
    var books: [Book]
}
