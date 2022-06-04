//
//  CreateBookshelf.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/6/2022.
//

import Foundation

class CreateBookshelf: CreateBookshelfUseCaseProtocol {
	
	private let bookshelfRepo: BookshelfRepositoryProtocol
	
	init(repo: BookshelfRepositoryProtocol) {
		self.bookshelfRepo = repo
	}
	
	func execute(id: String, data: Bookshelf) async -> Result<Bool, CustomStorageError> {
		await bookshelfRepo.createBookshelf(id: id, data: data)
	}
	
}
