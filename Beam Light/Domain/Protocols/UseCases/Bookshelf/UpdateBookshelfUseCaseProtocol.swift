//
//  UpdateBookshelfUseCaseProtocol.swift
//  Beam Light
//
//  Created by Gerry Gao on 4/6/2022.
//

import Foundation

protocol UpdateBookshelfUseCaseProtocol {
	func execute(_ id: String, _ data: Bookshelf) async -> Result<Bool, CustomStorageError>
}
