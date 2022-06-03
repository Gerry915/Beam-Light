//
//  DiskStorageWrapper.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/6/2022.
//

import Foundation

class DiskStorageWrapper: DiskStorageWrapperProtocol {
	
	var diskStorage: DiskStorage
	
	init() {
		self.diskStorage = DiskStorage()
	}
	
	func getData() throws -> [Data] {
		try diskStorage.fetchAll()
	}
	
	func create(id: String, data: Data) throws {
		try diskStorage.create(id: id, data: data)
	}

}
