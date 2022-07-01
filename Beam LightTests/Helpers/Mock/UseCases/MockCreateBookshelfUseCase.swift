//
//  MockCreateBookshelfUseCase.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 1/7/2022.
//

import Foundation
@testable import Beam_Light

class MockCreateBookshelfUseCase: CreateBookshelfUseCaseProtocol {
	var isSuccess = true
	var isCreated = false
	func execute(id: String, data: Bookshelf) async -> Result<Bool, CustomStorageError> {
		if isSuccess {
			isCreated = true
			return .success(true)
		} else {
			return .failure(.Create(message: "Cannot create"))
		}
	}
}
