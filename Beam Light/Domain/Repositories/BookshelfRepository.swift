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
			
			return await dataSource.create(id, dataToSave)
			
		} catch {
			return .failure(.Create(message: "Cannot encode data"))
		}
	}
	
	func deleteBookshelf(id: String) async -> Result<Bool, CustomStorageError> {
		return await dataSource.delete(id)
	}
	
	func updateBookshelf(id: String, data: Bookshelf) async -> Result<Bool, CustomStorageError> {
		
		do {
			let dataToUpdate = try JSONEncoder().encode(data)
			
			return await dataSource.update(id, dataToUpdate)
		} catch {
			return .failure(.Create(message: "Cannot encode data"))
		}
	}
	
}
