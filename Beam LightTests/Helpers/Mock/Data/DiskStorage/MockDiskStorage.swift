//
//  MockDiskStorage.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 6/6/2022.
//

@testable import Beam_Light
import Foundation

final class MockDiskStorage: DiskStorageWrapperProtocol {
	
	var fetchAllResult: [Data] = []
	var fetchResult: Data = Data()
	var saveGotCalled = false
	var itemToSave: Data!
	
	var getThrows = false
	
	func create(id: String, data: Data) throws {
		if getThrows {
			throw CustomStorageError.Create(message: "Cannot Create")
		}
		saveGotCalled = true
	}
	
	func delete(id: String) throws {
		if getThrows {
			throw CustomStorageError.Delete(message: "Cannot Delete")
		}
		saveGotCalled = true
	}
	
	func update(id: String, data: Data) throws {
		if getThrows {
			throw CustomStorageError.Update(message: "cannot save")
		}
		itemToSave = data
	}
	
	func getData() throws -> [Data] {
		if getThrows {
			throw CustomStorageError.Get(message: "Cannot fetch all")
		}
		
		return fetchAllResult
	}
	
	func getDataWith(id: String) throws -> Data {
		if getThrows {
			throw CustomStorageError.Get(message: "Cannot get with id: \(id)")
		}
		
		return fetchResult
	}
	
	func save(_ id: String, _ data: Data) throws {
		if getThrows {
			throw CustomStorageError.Update(message: "cannot save")
		}
		getThrows = true
	}
}
