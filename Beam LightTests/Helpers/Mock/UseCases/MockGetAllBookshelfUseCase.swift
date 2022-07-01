//
//  MockGetAllBookshelfUseCase.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 1/7/2022.
//

import Foundation
@testable import Beam_Light

class MockGetAllBookshelfUseCase: GetAllBookshelfUseCaseProtocol {
	
	var isSuccess = true
	var stub = [
		Bookshelf(id: UUID(), title: "test1", books: [], createAt: Date(), modifiedAt: Date()),
		Bookshelf(id: UUID(), title: "test2", books: [], createAt: Date(), modifiedAt: Date())
	]
	
	func execute() async -> Result<[Bookshelf], CustomStorageError> {
		
		if isSuccess {
			return .success(stub)
		} else {
			return .failure(.Get(message: "Cannot Get"))
		}
	}
}
