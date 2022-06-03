//
//  GetAllBookshelf.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/6/2022.
//

import Foundation

class GetAllBookshelf: GetAllBookshelfUseCaseProtocol {
	
	private let bookshelfRepo: BookshelfRepository
	
	init(repo: BookshelfRepository) {
		self.bookshelfRepo = repo
	}
	
	func execute() async -> Result<[Bookshelf], CustomStorageError> {
		await bookshelfRepo.getAllBookshelf()
	}
	
}
