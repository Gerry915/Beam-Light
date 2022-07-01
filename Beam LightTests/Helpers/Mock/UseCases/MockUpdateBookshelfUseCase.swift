//
//  MockUpdateBookshelfUseCase.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 1/7/2022.
//

import Foundation
@testable import Beam_Light

class MockUpdateBookshelfUseCase: UpdateBookshelfUseCaseProtocol {
	var isSuccess = true
	var isUpdated = false
	func execute(_ id: String, _ data: Bookshelf) async -> Result<Bool, CustomStorageError> {
		if isSuccess {
			isUpdated = true
			return .success(true)
		} else {
			return .failure(.Update(message: "Cannot update"))
		}
	}
}
