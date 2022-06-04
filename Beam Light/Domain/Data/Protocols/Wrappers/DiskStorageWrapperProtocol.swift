//
//  DiskStorageWrapperProtocol.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/6/2022.
//

import Foundation

protocol DiskStorageWrapperProtocol {
	
	func getData() throws -> [Data]
	func getDataWith(id: String) throws -> Data
	func create(id: String, data: Data) throws
	func delete(id: String) throws
	func update(id: String, data: Data) throws
}
