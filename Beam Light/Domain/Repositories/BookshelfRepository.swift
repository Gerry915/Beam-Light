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
	
}
