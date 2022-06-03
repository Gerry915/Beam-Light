//
//  BookshelfRepository.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/6/2022.
//

import Foundation

class BookshelfRepository: BookshelfRepositoryProtocol {
	
	var dataSource: DiskStorageBookshelfDataSourceProtocol
	
	init(dataSource: DiskStorageBookshelfDataSourceProtocol) {
		self.dataSource = dataSource
	}
	
	func getAllBookshelf() async -> Result<[Bookshelf], CustomStorageError> {
		return await dataSource.getAll()
	}
	
	func createBookshelf(id: String, data: Bookshelf) async -> Result<Bool, CustomStorageError> {
		do {
			let dataToSave = try JSONEncoder().encode(data)
			try await dataSource.create(id: id, data: dataToSave)
			return .success(true)
		} catch {
			return .failure(.Create(message: "Can not Create your Bookshelf"))
		}
	}
	
}
