//
//  DiskStorageDataSourceTests.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 6/6/2022.
//

@testable import Beam_Light
import XCTest

class DiskStorageDataSourceTests: XCTestCase {
	
	let expectedData = (UUID(), "test", Date())
	var expectedItem: Bookshelf!
	var dbWrapper: MockDiskStorage!
	var ds: DiskStorageBookshelfDataSource!
	
    override func setUpWithError() throws {
		dbWrapper = MockDiskStorage()
        ds = DiskStorageBookshelfDataSource(dbWrapper: dbWrapper)
		expectedItem = Bookshelf(id: expectedData.0, title: expectedData.1, books: [], createAt: expectedData.2, modifiedAt: expectedData.2)
    }
	
	private func _encodeData(_ data: Bookshelf) -> Data {
		return try! JSONEncoder().encode(data)
	}
	
	func test_getAll_should_return_Bookshelf_list() async {
		
		dbWrapper.fetchAllResult = [_encodeData(expectedItem)]
		
		let response = await ds.getAll()
		
		XCTAssertEqual(response, .success([expectedItem]))
	}

	func test_getAll_should_return_failure_on_error() async {
		dbWrapper.getThrows = true
		
		let response = await ds.getAll()
		XCTAssertEqual(response, .failure(.Get(message: "Can not Get data from Disk Storage")))
	}
	
	func test_getOne_should_return_Bookshelf() async {
		
		dbWrapper.fetchResult = _encodeData(expectedItem)
		
		let response = await ds.getOne(UUID().uuidString)
		
		XCTAssertEqual(response, .success(expectedItem))
	}
	
	func test_getOne_should_return_failure_on_error() async {
		dbWrapper.getThrows = true
		let id = UUID().uuidString
		let response = await ds.getOne(id)
		XCTAssertEqual(response, .failure(.Get(message: "Cannot get Bookshelf with ID: \(id)")))
	}
	
	func test_create() async {
		
		let response = await ds.create(expectedData.0.uuidString, _encodeData(expectedItem))
		
		XCTAssertTrue(dbWrapper.saveGotCalled)
		XCTAssertEqual(response, .success(true))
	}
	
	func test_create_should_return_failure_on_error() async {
		dbWrapper.getThrows = true
		
		let response =  await ds.create(expectedData.0.uuidString, _encodeData(expectedItem))
		
		XCTAssertFalse(dbWrapper.saveGotCalled)
		XCTAssertEqual(response, .failure(.Create(message: "Cannot create Object for id: \(expectedData.0.uuidString)")))
	}
	
	func test_delete_should_call_true() async {
		
		let response = await ds.delete(UUID().uuidString)
		
		XCTAssertTrue(dbWrapper.saveGotCalled)
		XCTAssertEqual(response, .success(true))
	}
	
	func test_delete_should_return_failure_on_error() async {
		
		let id = UUID()
		dbWrapper.getThrows = true
		
		let response = await ds.delete(id.uuidString)
		
		XCTAssertEqual(response, .failure(.Delete(message: "Cannot delete object with id: \(id)")))
	}
	
	func test_update_should_call_true() async {
	
		let mockData = expectedItem
		
		dbWrapper.fetchResult = _encodeData(mockData!)
		
		var updateData = expectedItem
		updateData!.title = "Other name"
		
		let response = await ds.update(expectedData.0.uuidString, _encodeData(updateData!))
		
		let itemToUpdate = try! JSONDecoder().decode(Bookshelf.self, from: dbWrapper.itemToSave)
		
		XCTAssertEqual(itemToUpdate.id, mockData?.id)
		XCTAssertEqual(itemToUpdate.title, updateData?.title)
		XCTAssertEqual(response, .success(true))
	}
	
	func test_update_should_return_failure_on_error() async {
		
		let mockData = expectedItem
		
		dbWrapper.fetchResult = _encodeData(mockData!)
		
		var updateData = expectedItem
		updateData!.title = "Other name"
		dbWrapper.getThrows = true
		
		let response = await ds.update(expectedData.0.uuidString, _encodeData(updateData!))
		
		XCTAssertFalse(dbWrapper.saveGotCalled)
		XCTAssertEqual(response, .failure(.Update(message: "Cannot update object with id \(updateData!.id.uuidString)")))
	}
}
