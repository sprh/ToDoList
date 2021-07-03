//
//  ToDoService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 02.07.2021.
//

import Foundation

final class ToDoService {
    let fileCache: FileCache
    let networkingService: DefaultNetworkingService
    private let itemsQueue = DispatchQueue(label: "ToDoService", attributes: [.concurrent])
    init(fileCache: FileCache, networkingService: DefaultNetworkingService) {
        self.fileCache = fileCache
        self.networkingService = networkingService
    }
    func getToDoItem(id: String) -> ToDoItem? {
        return fileCache.get(with: id)
    }
    func getToDoItems(withDone: Bool) -> [ToDoItem] {
        if withDone {
            return fileCache.toDoItems
        }
        return fileCache.toDoItems.filter({!$0.done})
    }
    func update(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<Void, Error>) -> Void) {
        fileCache.add(item: item)
        networkingService.update(item) { [weak self] result in
            switch result {
            case let .success(item):
                self?.replaceAndSave(item: item, queue: queue, completion: completion)
            case let .failure(error):
                let dirtyItem = ToDoItem(id: item.id,
                                         text: item.text,
                                         importance: item.importance,
                                         deadline: item.deadline,
                                         color: item.color,
                                         done: item.done,
                                         updatedAt: item.updatedAt,
                                         createdAt: item.createdAt,
                                         isDirty: true)
                self?.fileCache.add(item: dirtyItem)
                queue.async {
                    completion(.failure(error))
                }
            }
        }
    }
    func delete(_ id: String, queue: DispatchQueue, completion: @escaping (Result<Void, Error>) -> Void) {
        fileCache.delete(with: id)
        networkingService.delete(id) { [weak self] result in
            print(result)
            switch result {
            case .success(_):
                completion(.success(()))
            case let .failure(error):
                self?.fileCache.addTombstone(tombstone: Tombstone(id: id))
                completion(.failure(error))
            }
        }
    }
    func create(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<Void, Error>) -> Void) {
        fileCache.add(item: item)
        networkingService.create(item) { [weak self] result in
            switch result {
            case let .success(item):
                self?.replaceAndSave(item: item, queue: queue, completion: completion)
            case let .failure(error):
                let dirtyItem = ToDoItem(id: item.id,
                                         text: item.text,
                                         importance: item.importance,
                                         deadline: item.deadline,
                                         color: item.color,
                                         done: item.done,
                                         updatedAt: item.updatedAt,
                                         createdAt: item.createdAt,
                                         isDirty: true)
                self?.fileCache.add(item: dirtyItem)
                completion(.failure(error))
            }
        }
    }
    func replaceAndSave(item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<Void, Error>) -> Void) {
        replace(item: item) { [weak self] in
            self?.fileCache.saveFile {result in
                switch result {
                case let .failure(error):
                    queue.async {
                        completion(.failure(error))
                    }
                case .success():
                    queue.async {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    func merge(items: [ToDoItem], completion: @escaping ([ToDoItem]) -> Void) {
        itemsQueue.async { [weak self] in
            guard let self = self else {return}
            let cacheItems = self.fileCache.toDoItems
            var newItems: [ToDoItem] = []
            for item in items {
                if let cacheItem = cacheItems.first(where: {$0.id == item.id}) {
                   if let cacheUpdatedAt = cacheItem.updatedAt,
                      let itemUpdatedAt = item.updatedAt,
                      cacheUpdatedAt < itemUpdatedAt {
                        newItems.append(item)
                   } else {
                    newItems.append(cacheItem)
                   }
                } else {
                    newItems.append(item)
                }
            }
            completion(newItems)
        }
    }
    func replace(item: ToDoItem, completion: @escaping () -> Void) {
        itemsQueue.async(flags: [.barrier]) { [weak self] in
            guard let self = self else {return}
            self.fileCache.add(item: item)
        }
        completion()
    }
    func replace(items: [ToDoItem], completion: @escaping () -> Void) {
        itemsQueue.async(flags: [.barrier]) { [weak self] in
            guard let self = self else {return}
            items.forEach({self.fileCache.add(item: $0)})
        }
        completion()
    }
    func loadFromServer(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        networkingService.getAll { [weak self] result in
            switch result {
            case let .success(items):
                self?.merge(items: items) { items in
                    queue.async {
                        self?.fileCache.reloadItems(toDoItems: items) {
                            completion(.success(items))
                        }
                    }
                }
            case .failure(_):
                self?.loadFromFile(queue: queue, completion: completion)
            }
        }
    }
    func loadFromFile(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        fileCache.loadFile { result in
            queue.async {
                completion(result)
            }
        }
    }
    func synchronize(item: ToDoItem?, idToDelete: String?, queue: DispatchQueue,
                     completion: @escaping (Result<Void, Error>) -> Void) {
        var dirties = fileCache.getDirties()
        var tombstones = fileCache.tombstones.map({$0.id})
        if let item = item {
            dirties.append(item)
        }
        if let id = idToDelete {
            tombstones.append(id)
        }
        networkingService.putAll(addOrUpdateItems: dirties,
                                 deleteIds: tombstones) { [weak self] result in
            switch result {
            case let .failure(error):
                queue.async {
                    completion(.failure(error))
                }
            case let .success(items):
                queue.async {
                    self?.fileCache.clearTombstones()
                    self?.fileCache.reloadItems(toDoItems: items) {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    private func needToSynchronize() -> Bool {
        return fileCache.getDirties().count != 0 || fileCache.tombstones.count != 0
    }
}
