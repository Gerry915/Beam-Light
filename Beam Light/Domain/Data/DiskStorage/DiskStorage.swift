//
//  DiskStorage.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/6/2022.
//

import Foundation

public final class DiskStorage {
	
	private var saveDirectory: URL {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BeamLight").appendingPathComponent("bookshelf")
	}
	
	required init() {
		_createDirectory()
	}
	
	func create(id: String, data: Data) throws {
		
		let location = saveDirectory.appendingPathComponent(id)

		try data.write(to: location)
	}
	
	func delete(id: String) throws {
		
		let path = _locationOnDisk(for: id)
		
		try FileManager.default.removeItem(at: path)
	}
	
	func fetch(_ id: String) throws -> Data{
		try Data(contentsOf: _locationOnDisk(for: id))
	}
	
	func fetchAll() throws -> [Data] {
		
		var result = [Data]()
		
		let directoryContents = try FileManager.default.contentsOfDirectory(at: saveDirectory, includingPropertiesForKeys: nil)
		
		try directoryContents.forEach { url in
			let data = try Data(contentsOf: url)
			result.append(data)
		}
		
		return result
	}
	
	func save(_ id: String, _ data: Data) throws {
		let location = saveDirectory.appendingPathComponent(id)
		try data.write(to: location)
	}
}

private extension DiskStorage {
	func _createDirectory() {
		do {
			try FileManager.default.createDirectory(at: saveDirectory, withIntermediateDirectories: true, attributes: nil)
		} catch let error {
			print(error)
			fatalError("Unable to create dir")
		}
	}
	
	func _locationOnDisk(for bookshelfName: String) -> URL {
		return saveDirectory.appendingPathComponent(bookshelfName)
	}
}
