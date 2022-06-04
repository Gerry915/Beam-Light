//
//  DeleteBookshelfUseCaseProtocol.swift
//  Beam Light
//
//  Created by Gerry Gao on 4/6/2022.
//

import Foundation

protocol DeleteBookshelfUseCaseProtocol {
	func execute(id: String) async -> Result<Bool, CustomStorageError>
}
