//
//  MockDeleteBookshelfUseCase.swift
//  Beam LightTests
//
//  Created by Gerry Gao on 1/7/2022.
//

import Foundation
@testable import Beam_Light

class MockDeleteBookshelfUseCase: DeleteBookshelfUseCaseProtocol {
	var isSuccess = true
	var isDeleted = false
	func execute(id: String) async -> Result<Bool, CustomStorageError> {
		if isSuccess {
			isDeleted = true
			return .success(true)
		} else {
			return .failure(.Delete(message: "Cannot delete"))
		}
	}
}
