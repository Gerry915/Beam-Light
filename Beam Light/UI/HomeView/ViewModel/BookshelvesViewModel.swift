//
//  HomeViewModel.swift
//  Beam Light
//
//  Created by Gerry Gao on 11/3/2022.
//

import Foundation

class BookshelvesViewModel {
    
	// MARK: - Use Cases
	private var getAllUseCase: GetAllBookshelfUseCaseProtocol
	private var createBookshelfUseCase: CreateBookshelfUseCaseProtocol
	private var deleteBookshelfUseCase: DeleteBookshelfUseCaseProtocol
	private var updateBookshelfUseCase: UpdateBookshelfUseCaseProtocol
	
    // MARK: - Properties
    @Published private(set) var bookshelves: [Bookshelf] = []
	
	var errorMessage: ((String) -> Void)?
    
    // MARK: - Init
	init(
		 getAllUseCase: GetAllBookshelfUseCaseProtocol,
		 createBookshelfUseCase: CreateBookshelfUseCaseProtocol,
		 deleteBookshelfUseCase: DeleteBookshelfUseCaseProtocol,
		 updateBookshelfUseCase: UpdateBookshelfUseCaseProtocol
	) {
		self.getAllUseCase = getAllUseCase
		self.createBookshelfUseCase = createBookshelfUseCase
		self.deleteBookshelfUseCase = deleteBookshelfUseCase
		self.updateBookshelfUseCase = updateBookshelfUseCase
    }
    
    // MARK: - Methods
	func getAllBookshelf() async {
		let result = await getAllUseCase.execute()
		switch result {
		case .success(let data):
			bookshelves = data
		case .failure(let error):
			if case let .Get(message) = error {
				errorMessage?(message)
			}
		}
	}
    
    func getBookshelf(for idx: Int) -> Bookshelf {
        return bookshelves[idx]
    }
	
    func saveBookshelfOrder(sourceIndex: Int, destinationIndex: Int) {
        bookshelves.swapAt(sourceIndex, destinationIndex)
    }
	
	func create(with title: String) async {
		let uuid = UUID()
		
		let bookshelf = Bookshelf(id: uuid, title: title, books: [], createAt: Date(), modifiedAt: Date())
		
		await _updateState(result: createBookshelfUseCase.execute(id: uuid.uuidString, data: bookshelf))
	}
	
	func deleteBookshelf(_ id: String) async {
		await _updateState(result: deleteBookshelfUseCase.execute(id: id))
	}
	
	func updateBookshelf(bookshelf: Bookshelf) async {
		await _updateState(result: updateBookshelfUseCase.execute(bookshelf.id.uuidString, bookshelf))
	}
	
	private func _updateState(result: Result<Bool, CustomStorageError>) async {
		switch result {
		case .success(_):
			await getAllBookshelf()
		case .failure(let error):
			if case let .Delete(message) = error {
				errorMessage?(message)
			}
			if case let .Update(message) = error {
				errorMessage?(message)
			}
			if case let .Create(message) = error {
				errorMessage?(message)
			}
			if case let .Get(message) = error {
				errorMessage?(message)
			}
		}
	}
    
	func batchDelete(ids: [Int]) async {
		for id in ids {
			await deleteBookshelf(getBookshelf(for: id).id.uuidString)
		}
	}
}
