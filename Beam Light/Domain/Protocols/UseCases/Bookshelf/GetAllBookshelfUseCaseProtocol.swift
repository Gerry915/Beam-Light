//
//  GetAllBookshelfUseCaseProtocol.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/6/2022.
//

import Foundation

protocol GetAllBookshelfUseCaseProtocol {
	func execute() async -> Result<[Bookshelf], CustomStorageError>
}
