//
//  HomeViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 11/3/2022.
//

import Foundation

class BookshelvesViewModel {
    
    // MARK: - Properties
	
	private let getAllUseCase: GetAllBookshelfUseCaseProtocol
	private let createBookshelfUseCase: CreateBookshelfUseCaseProtocol
    
    @Published private(set) var bookshelves: [Bookshelf] = []
    
    var loader: StorageService

    var isLoading: Bool = true

    var isEmpty: Bool {
        return bookshelves.isEmpty
    }
    
    // MARK: - Init
    
	init(loader: StorageService, getAllUseCase: GetAllBookshelfUseCaseProtocol, createBookshelfUseCase: CreateBookshelfUseCaseProtocol) {
        self.loader = loader
		self.getAllUseCase = getAllUseCase
		self.createBookshelfUseCase = createBookshelfUseCase
    }
    
    // MARK: - Methods
    var numberOfItems: Int {
        return bookshelves.count
    }
    
    func getBookshelf(for idx: Int) -> Bookshelf {
        return bookshelves[idx]
    }
	
	func getAllBookshelf() async {
		let result = await getAllUseCase.execute()
		if case let .success(bookshelves) = result {
			self.bookshelves = bookshelves
		}
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
	
	
    
    func saveAll() {
        bookshelves.forEach { bookshelf in
            loader.save(id: bookshelf.id.uuidString, data: bookshelf) { success in
                if !success {
                    print("fail to save item!")
                }
            }
        }
    }
    
    func saveBookshelfOrder(sourceIndex: Int, destinationIndex: Int) {
        bookshelves.swapAt(sourceIndex, destinationIndex)
        bookshelves.forEach({print($0.title)})
    }
	
	func create(with title: String) async {
		// 1. Create UUID for bookshelf
		let uuid = UUID()
		
		// 2. Create bookshelf with id, title, and empty books array
		let bookshelf = Bookshelf(id: uuid, title: title, books: [], createAt: Date(), modifiedAt: Date())
		
		let result = await createBookshelfUseCase.execute(id: uuid.uuidString, data: bookshelf)
		
		if case .success(_) = result {
			await getAllBookshelf()
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
    
    func deleteMultiItem(for idxs: [IndexPath], completion: @escaping (Bool) -> Void) {
        
        var idArray: [String] = []
        
        idxs.forEach { id in
            let bookshelfID = getBookshelfID(for: id.row)
            bookshelves.remove(at: id.row)
            idArray.append(bookshelfID)
        }
        
        loader.deleteMultiItem(ids: idArray) { success in
            completion(true)
        }
        
    }
    
    private func getBookshelfID(for idx: Int) -> String {
        return bookshelves[idx].id.uuidString
    }
}
