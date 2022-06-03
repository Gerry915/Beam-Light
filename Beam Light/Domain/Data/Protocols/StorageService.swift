//
//  StorageService.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import Foundation

protocol StorageService {
    
    func save<T: Codable>(id: String, data: T, completion: ((Bool) -> Void)?)
    
    func delete(id: String, completion: ((Bool) -> Void)?)
    
    func deleteMultiItem(ids: [String], completion: ((Bool) -> Void)?)
    
    func fetch<T: Codable>(id: String, completion: @escaping (Result<T, Error>) -> Void)
    
    func fetchAll<T: Codable>(completion: @escaping (Result<[T], Error>) -> Void)
}
