//
//  DiskStorageBookshelfDataSource.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/6/2022.
//

import Foundation

class DiskStorageBookshelfDataSource: DiskStorageBookshelfDataSourceProtocol {
	
	var dbWrapper: DiskStorageWrapperProtocol
	
	init(dbWrapper: DiskStorageWrapperProtocol) {
		self.dbWrapper = dbWrapper
	}
	
	private func _getAll() throws -> [Bookshelf] {
		let result = try dbWrapper.getData()
		
		return try result.map { item in
			try JSONDecoder().decode(Bookshelf.self, from: item)
		}
	}
	
	func getAll() async -> Result<[Bookshelf], CustomStorageError> {
		do {
			let data = try _getAll()
			return .success(data)
		} catch {
			return .failure(.Get(message: "Can not Get data from Disk Storage"))
		}
	}
}
