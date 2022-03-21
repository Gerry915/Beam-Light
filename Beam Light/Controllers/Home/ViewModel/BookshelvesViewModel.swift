//
//  HomeViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 11/3/2022.
//

import Foundation

class BookshelvesViewModel {
    
    // MARK: - Properties
    
    private var bookshelves: [Bookshelf] = []
    
    var loader: StorageService

    var isLoading: Bool = true

    var isEmpty: Bool {
        return bookshelves.isEmpty
    }
    
    // MARK: - Init
    
    init(loader: StorageService) {
        self.loader = loader
    }
    
    // MARK: - Methods
    var numberOfItems: Int {
        return bookshelves.count
    }
    
    func getBookshelf(for idx: Int) -> Bookshelf {
        return bookshelves[idx]
    }
    
    func loadData(completion: @escaping (Bool) -> Void) {
        isLoading = true
        loader.fetchAll { [weak self] (result: Result<[Bookshelf], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let sortedData = data.sorted(by: { $0.createAt > $1.createAt })
                self.bookshelves = sortedData
                completion(true)
                self.isLoading = false
            case .failure(let failure):
                print(failure)
                completion(false)
            }
        }
    }
    
    func saveBookToBookshelf(at idx: Int, with book: Book, completion: @escaping (Bool) -> Void) {
        var updateItem = getBookshelf(for: idx)
        updateItem.books.append(book)
        let updateID = getBookshelfID(for: idx)
        
        loader.save(id: updateID, data: updateItem) { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func save(title: String, completion: ((Bool) -> Void)?) {
        // 1. Create UUID for bookshelf
        let uuid = UUID()
        
        // 2. Create bookshelf with id, title, and empty books array
        let bookshelf = Bookshelf(id: uuid, title: title, books: [], createAt: Date(), modifiedAt: Date())
        
        bookshelves.insert(bookshelf, at: 0)

        // 3. Save bookshelf
        loader.save(id: uuid.uuidString, data: bookshelf) { success in
            if success { completion?(true) }
        }
    }
    
    func delete(for idx: Int, completion: @escaping (Bool) -> Void) {
        
        let id = getBookshelfID(for: idx)
        
        bookshelves.remove(at: idx)

        loader.delete(id: id) { success in
            completion(success)
        }
    }
    
    private func getBookshelfID(for idx: Int) -> String {
        return bookshelves[idx].id.uuidString
    }
}
