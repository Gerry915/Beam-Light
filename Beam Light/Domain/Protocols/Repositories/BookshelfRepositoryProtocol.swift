//
//  BookshelfRepositoryProtocol.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/6/2022.
//

import Foundation

protocol BookshelfRepositoryProtocol {
	func getAllBookshelf() async -> Result<[Bookshelf], CustomStorageError>
}
