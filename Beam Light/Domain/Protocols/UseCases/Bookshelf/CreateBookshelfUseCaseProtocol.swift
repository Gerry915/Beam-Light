//
//  CreateBookshelfUseCaseProtocol.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/6/2022.
//

import Foundation

protocol CreateBookshelfUseCaseProtocol {
	func execute(id: String, data: Bookshelf) async -> Result<Bool, CustomStorageError>
}
