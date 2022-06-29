//
//  MockBookshelfDataSource.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 6/6/2022.
//

@testable import Beam_Light
import Foundation

final class MockBookshelfDataSource: DiskStorageBookshelfDataSourceProtocol {
	
	var getAllResult: Result<[Bookshelf], CustomStorageError> = .success([])
	var getAllGotCalled  = false
	
	func getAll() async -> Result<[Bookshelf], CustomStorageError> {
		getAllGotCalled = true
		return getAllResult
	}
	
	var getOneResult: Result<Bookshelf, CustomStorageError> = .success(Bookshelf(id: UUID(), title: "test", books: [], createAt: Date(), modifiedAt: Date()))
	var getOneGotCalledWith  = (UUID().uuidString)
	
	func getOne(_ id: String) async -> Result<Bookshelf, CustomStorageError> {
		getOneGotCalledWith = (id)
		return getOneResult
	}
	
	var createResult: Result<Bool, CustomStorageError>  = .success(false)
	var createGotCalledWith  = (UUID().uuidString, Data())
	func create(_ id: String, _ data: Data) async -> Result<Bool, CustomStorageError> {
		createGotCalledWith = (id, data)
		return createResult
	}
	
	var deleteResult: Result<Bool, CustomStorageError> = .success(false)
	var deleteGotCalledWith = (UUID().uuidString)
	func delete(_ id: String) async -> Result<Bool, CustomStorageError> {
		deleteGotCalledWith = (id)
		return deleteResult
	}
	
	var updateResult: Result<Bool, CustomStorageError> = .success(false)
	var updateGotCalledWith = (UUID().uuidString, Data())
	func update(_ id: String, _ data: Data) async -> Result<Bool, CustomStorageError> {
		updateGotCalledWith = (id, data)
		return updateResult
	}
}
