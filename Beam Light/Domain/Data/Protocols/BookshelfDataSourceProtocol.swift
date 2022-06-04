//
//  BookshelfDataSourceProtocol.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/6/2022.
//

import Foundation

protocol DiskStorageBookshelfDataSourceProtocol {
	
	func getOne(_ id: String) async -> Result<Bookshelf, CustomStorageError>
	
	func getAll() async -> Result<[Bookshelf], CustomStorageError>
	
	func create(_ id: String, _ data: Data) async -> Result<Bool, CustomStorageError>
	
	func delete(_ id: String) async -> Result<Bool, CustomStorageError>
	
	func update(_ id: String, _ data: Data) async -> Result<Bool, CustomStorageError>
}
