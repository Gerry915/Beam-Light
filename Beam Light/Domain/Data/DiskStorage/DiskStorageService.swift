//
//  DiskStorageService.swift
//  Beam Light
//
//  Created by Gerry Gao on 5/3/2022.
//

import Foundation

enum StorageError: Error {
    case fetchError(message: String, error: Error?)
    case decodeError(message: String, error: Error?)
}

class DiskStorageService: StorageService {
    
    static let shared = DiskStorageService()
    
    private let saveOnDiskBackgroundQueue = DispatchQueue(label: "au.com.genggao.saveOnDiskQueue", qos: .background)
    private let fetchDataQueue = DispatchQueue(label: "au.com.genggao.fetchDataQueue", qos: .userInitiated)
    
    private var saveDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BeamLight").appendingPathComponent("bookshelf")
    }
    
    private init() {
        createDirectory()
    }
    
    func save<T>(id: String, data: T, completion: ((Bool) -> Void)?) where T : Decodable, T : Encodable {
        do {
            let saveData = try JSONEncoder().encode(data)
            let location = saveDirectory.appendingPathComponent(id)

            saveOnDiskBackgroundQueue.async {
                do {
                    try saveData.write(to: location)
                    completion?(true)
                } catch let error {
                    completion?(false)
                    print(error)
                }
            }
        } catch let error {
            completion?(false)
            print(error)
        }
    }
    
    func delete(id: String, completion: ((Bool) -> Void)?) {
        let path = locationOnDisk(for: id)
        saveOnDiskBackgroundQueue.async {
            do {
                try FileManager.default.removeItem(at: path)
                completion?(true)
            } catch let error {
                print(error)
                completion?(false)
            }
        }
    }
    
    func deleteMultiItem(ids: [String], completion: ((Bool) -> Void)?) {
        ids.forEach { id in
            let path = locationOnDisk(for: id)
            saveOnDiskBackgroundQueue.async {
                do {
                    try FileManager.default.removeItem(at: path)
                } catch let error {
                    print(error)
                    completion?(false)
                }
            }
        }
        completion?(true)
    }
    
    func fetchAll<T: Codable>(completion: @escaping (Result<[T], Error>) -> Void) {
        
		var result = [T]()
        
        fetchDataQueue.async { [self] in
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: saveDirectory, includingPropertiesForKeys: nil)

                directoryContents.forEach { url in
                    guard let data = try? Data(contentsOf: url) else {
                        completion(.failure(StorageError.fetchError(message: "cannot fetch data", error: nil)))
                        return
                    }
                    do {
                        let decodeData = try JSONDecoder().decode(T.self, from: data)
                        result.append(decodeData)
                    } catch let error {
                        completion(.failure(StorageError.decodeError(message: "Cannot decode Object", error: error)))
                    }
                }
                completion(.success(result))
            } catch let error {
                completion(.failure(StorageError.fetchError(message: "Cannot fetch data", error: error)))
            }
        }
    }
    
    func fetch<T>(id: String, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        fetchDataQueue.async {
            guard let data = try? Data(contentsOf: self.locationOnDisk(for: id)) else {
                completion(.failure(StorageError.fetchError(message: "Cannot fetch data from URL", error: nil)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch let error {
                completion(.failure(StorageError.decodeError(message: "Cannot decode Object", error: error)))
            }
        }
    }
    
    private func createDirectory() {
        do {
            try FileManager.default.createDirectory(at: saveDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error)
            fatalError("Unable to create dir")
        }
    }
    
    private func locationOnDisk(for bookshelfName: String) -> URL {
        return saveDirectory.appendingPathComponent(bookshelfName)
    }
}
