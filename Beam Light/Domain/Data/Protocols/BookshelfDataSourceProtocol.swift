//
//  BookshelfDataSourceProtocol.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/6/2022.
//

import Foundation

protocol DiskStorageBookshelfDataSourceProtocol {
	func getAll() async -> Result<[Bookshelf], CustomStorageError>
	
	func create(id: String, data: Data) async throws
}
