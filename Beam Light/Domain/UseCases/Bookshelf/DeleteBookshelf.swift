//
//  DeleteBookshelf.swift
//  Beam Light
//
//  Created by Gerry Gao on 4/6/2022.
//

import Foundation

class DeleteBookshelf: DeleteBookshelfUseCaseProtocol {
	
	private let repo: BookshelfRepositoryProtocol
	
	init(repo: BookshelfRepositoryProtocol) {
		self.repo = repo
	}
	
	func execute(id: String) async -> Result<Bool, CustomStorageError> {
		await repo.deleteBookshelf(id: id)
	}
}
