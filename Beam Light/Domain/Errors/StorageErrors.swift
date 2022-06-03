//
//  StorageErrors.swift
//  Beam Light
//
//  Created by Gerry Gao on 2/6/2022.
//

enum CustomStorageError: Error {
	case Create(message: String)
	case Get(message: String)
	case Update(message: String)
	case Delete(message: String)
}
