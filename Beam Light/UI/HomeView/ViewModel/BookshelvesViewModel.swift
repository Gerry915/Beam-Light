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
    
    func getBookshelf(for idx: Int) -> Bookshelf {
        return bookshelves[idx]
    }
	
	func getAllBookshelf() async {
		let result = await getAllUseCase.execute()
		if case let .success(bookshelves) = result {
			self.bookshelves = bookshelves
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
	
	func deleteBookshelf(_ id: String) async {
		let result = await deleteBookshelfUseCase.execute(id: id)
		
		if case .success(_) = result {
			await getAllBookshelf()
		}
	}
	
	func updateBookshelf(bookshelf: Bookshelf) async {
		let result = await updateBookshelfUseCase.execute(bookshelf.id.uuidString, bookshelf)
		
		if case .success(_) = result {
			await getAllBookshelf()
		}
	}
    
	func batchDelete(ids: [Int]) {
		ids.forEach { id in
			let bookshelf = getBookshelf(for: id)
			Task {
				await deleteBookshelf(bookshelf.id.uuidString)
			}
		}
	}
}
