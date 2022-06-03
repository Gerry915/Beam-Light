//
//  DiskStorage.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/6/2022.
//

import Foundation

class DiskStorage {
	
	private let saveOnDiskBackgroundQueue = DispatchQueue(label: "au.com.genggao.saveOnDiskQueue", qos: .background)
	private let fetchDataQueue = DispatchQueue(label: "au.com.genggao.fetchDataQueue", qos: .userInitiated)
	
	private var saveDirectory: URL {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BeamLight").appendingPathComponent("bookshelf")
	}
	
	required init() {
		createDirectory()
	}
	
	func save(id: String, data: Data) throws {
		
		let location = saveDirectory.appendingPathComponent(id)

		try data.write(to: location)
	}
	
	func delete(id: String) throws {
		
		let path = locationOnDisk(for: id)
		
		try FileManager.default.removeItem(at: path)
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
	
	private func createDirectory() {
		do {
			try FileManager.default.createDirectory(at: saveDirectory, withIntermediateDirectories: true, attributes: nil)
		} catch let error {
			print(error)
			fatalError("Unable to create dir")
		}
	}
	
	private func locationOnDisk(for bookshelfName: String) -> URL {
		return saveDirectory.appendingPathComponent(bookshelfName)
	}
}
