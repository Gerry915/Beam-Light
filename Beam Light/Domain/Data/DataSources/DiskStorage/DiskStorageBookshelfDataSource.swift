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
	
	private func _getOne(_ id: String) throws -> Bookshelf {
		let data = try dbWrapper.getDataWith(id: id)
		
		return try JSONDecoder().decode(Bookshelf.self, from: data)
	}
	
	private func _getAll() throws -> [Bookshelf] {
		let data = try dbWrapper.getData()
		
		return try data.map { item in
			try JSONDecoder().decode(Bookshelf.self, from: item)
		}
	}
	
	func getOne(_ id: String) async -> Result<Bookshelf, CustomStorageError> {
		do {
			let data = try _getOne(id)
			return .success(data)
		} catch {
			return .failure(.Get(message: "Cannot get Bookshelf with ID: \(id)"))
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
	
	func create(_ id: String, _ data: Data) async -> Result<Bool, CustomStorageError> {
		do {
			try dbWrapper.create(id: id, data: data)
			return .success(true)
		} catch {
			return .failure(.Create(message: "Cannot create Object for id: \(id)"))
		}
		
	}
	
	func delete(_ id: String) async -> Result<Bool, CustomStorageError> {
		do {
			try dbWrapper.delete(id: id)
			return .success(true)
		} catch {
			return .failure(.Delete(message: "Cannot delete object with id: \(id)"))
		}
	}
	
	func update(_ id: String, _ data: Data) async -> Result<Bool, CustomStorageError> {
		do {
			try dbWrapper.update(id: id, data: data)
			return .success(true)
		} catch {
			return .failure(.Update(message: "Cannot update object with id \(id)"))
		}
	}
	
}
