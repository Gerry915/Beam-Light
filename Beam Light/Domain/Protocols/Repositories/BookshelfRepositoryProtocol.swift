//
//  BookshelfRepositoryProtocol.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/6/2022.
//

import Foundation

protocol BookshelfRepositoryProtocol {
	func getAllBookshelf() async -> Result<[Bookshelf], CustomStorageError>
	
	func createBookshelf(id: String, data: Bookshelf) async -> Result<Bool, CustomStorageError>
	
	func deleteBookshelf(id: String) async -> Result<Bool, CustomStorageError>
	
	func updateBookshelf(id: String, data: Bookshelf) async -> Result<Bool, CustomStorageError>
}
