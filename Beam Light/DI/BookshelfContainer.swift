//
//  BookshelfContainer.swift
//  Beam Light
//
//  Created by Gerry Gao on 3/6/2022.
//

import Swinject

func buildContainer() -> Container {
	
	let container = Container()
	
	container.register(DiskStorageWrapperProtocol.self) { _ in
		return DiskStorageWrapper()
	}.inObjectScope(.container)
	
	container.register(DiskStorageBookshelfDataSourceProtocol.self) { _ in
		return DiskStorageBookshelfDataSource(dbWrapper: container.resolve(DiskStorageWrapperProtocol.self)!)
	}.inObjectScope(.container)
	
	container.register(BookshelfRepositoryProtocol.self) { _ in
		return BookshelfRepository(dataSource: container.resolve(DiskStorageBookshelfDataSourceProtocol.self)!)
	}.inObjectScope(.container)
	
	container.register(GetAllBookshelfUseCaseProtocol.self) { _ in
		return GetAllBookshelf(repo: container.resolve(BookshelfRepositoryProtocol.self)!)
	}.inObjectScope(.container)
	
	container.register(CreateBookshelfUseCaseProtocol.self) { _ in
		return CreateBookshelf(repo: container.resolve(BookshelfRepositoryProtocol.self)!)
	}.inObjectScope(.container)
	
	container.register(DeleteBookshelfUseCaseProtocol.self) { _ in
		return DeleteBookshelf(repo: container.resolve(BookshelfRepositoryProtocol.self)!)
	}.inObjectScope(.container)
	
	container.register(UpdateBookshelfUseCaseProtocol.self) { _ in
		return UpdateBookshelfUseCase(repo: container.resolve(BookshelfRepositoryProtocol.self)!)
	}.inObjectScope(.container)
	
	return container

}
