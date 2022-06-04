//
//  UpdateBookshelfUseCase.swift
//  Beam Light
//
//  Created by Gerry Gao on 4/6/2022.
//

import Foundation

class UpdateBookshelfUseCase: UpdateBookshelfUseCaseProtocol {
	
	var repo: BookshelfRepositoryProtocol
	
	init(repo: BookshelfRepositoryProtocol) {
		self.repo = repo
	}
	
	func execute(_ id: String, _ data: Bookshelf) async -> Result<Bool, CustomStorageError> {
		await repo.updateBookshelf(id: id, data: data)
	}
}
