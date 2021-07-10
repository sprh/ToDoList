//
//  ToDoService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 02.07.2021.
//

import Foundation
import Models

final class ToDoService {
    let fileCacheService: FileCacheService
    let networkingService: DefaultNetworkingService
    var items: [ToDoItem] = []
    private let itemsQueue = DispatchQueue(label: "ToDoService", attributes: [.concurrent])
    init(fileCacheService: FileCacheService, networkingService: DefaultNetworkingService) {
        self.fileCacheService = fileCacheService
        self.networkingService = networkingService
        loadFromFile(queue: itemsQueue) { result in
            switch result {
            case .failure(_):
                break
            case let .success(items):
                self.items = items
            }
        }
    }
    func getToDoItem(id: String) -> ToDoItem? {
        return items.first(where: {$0.id == id})
    }
    func getToDoItems(withDone: Bool) -> [ToDoItem] {
        return itemsQueue.sync {
            (!withDone ? items.filter({!$0.done}) : items).sorted(by: {$0.createdAt < $1.createdAt})
        }
    }
    func update(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        networkingService.update(item) { [weak self] result in
            if !(self?.items.contains(where: {$0.id == item.id}) ?? false) {
                self?.items.append(item)
            }
            guard let self = self,
                  let index = self.items.firstIndex(where: {$0.id == item.id}) else {return}
            switch result {
            case let .success(item):
                self.items[index] = item
                self.fileCacheService.update(item) { result in
                    queue.async {
                        completion(result)
                    }
                }
            case .failure(_):
                let dirtyItem = ToDoItem(id: item.id,
                                         text: item.text,
                                         importance: item.importance,
                                         deadline: item.deadline,
                                         color: item.color,
                                         done: item.done,
                                         updatedAt: item.updatedAt,
                                         createdAt: item.createdAt,
                                         isDirty: true)
                self.items[index] = dirtyItem
                self.fileCacheService.update(dirtyItem) { result in
                    queue.async {
                        completion(result)
                    }
                }
            }
        }
    }
    func delete(_ id: String, queue: DispatchQueue, completion: @escaping (Result<String, Error>) -> Void) {
        guard let index = items.firstIndex(where: {$0.id == id}) else {
            return
        }
        items.remove(at: index)
        networkingService.delete(id) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.fileCacheService.deleteToDoItem(id) { result in
                    queue.async {
                        completion(result)
                    }
                }
            case let .failure(error):
                self.fileCacheService.addTombstone(tombstone: Tombstone(id: id)) { _ in
                }
                queue.async {
                    completion(.failure(error))
                }
            }
        }
    }
    func create(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        networkingService.create(item) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.items.append(item)
                self.fileCacheService.create(item) {result in
                    queue.async {
                        completion(result)
                    }
                }
            case .failure(_):
                let dirtyItem = ToDoItem(id: item.id,
                                         text: item.text,
                                         importance: item.importance,
                                         deadline: item.deadline,
                                         color: item.color,
                                         done: item.done,
                                         updatedAt: item.updatedAt,
                                         createdAt: item.createdAt,
                                         isDirty: true)
                self.items.append(dirtyItem)
                self.fileCacheService.create(dirtyItem, completion: completion)
            }
        }
    }
    func merge(newItems: [ToDoItem], queue: DispatchQueue, completion: @escaping ([String], [ToDoItem]) -> Void) {
        var deletedItems: [String] = []
        var addedOrUpdatedItems: [ToDoItem] = []
        itemsQueue.async { [weak self] in
            guard let self = self else {return}
            let oldItems = self.items
            var items: [ToDoItem] = []
            let tombstones = self.fileCacheService.tombstones.map({$0.id})
            for newItem in newItems {
                if tombstones.contains(newItem.id) {
                    deletedItems.append(newItem.id)
                } else if let oldItem = oldItems.first(where: {$0.id == newItem.id}) {
                    if let oldUpdate = oldItem.updatedAt,
                       let newUpdate = newItem.updatedAt,
                       oldUpdate <= newUpdate {
                        items.append(newItem)
                    } else {
                        addedOrUpdatedItems.append(oldItem)
                        items.append(oldItem)
                    }
                } else {
                    items.append(newItem)
                }
            }
            self.items = items
            queue.async {
                completion(deletedItems, addedOrUpdatedItems)
            }
        }
    }
    func loadData(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        networkingService.getAll { [weak self] result in
            switch result {
            case .success(_):
                queue.async {
                    completion(result)
                }
            case .failure(_):
                self?.loadFromFile(queue: queue, completion: completion)
            }
        }
    }
    func loadFromFile(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        fileCacheService.loadFile { [weak self] result in
            switch result {
            case .failure(_):
                self?.items = []
            case let .success(items):
                self?.items = items
            }
            queue.async {
                completion(result)
            }
        }
    }
    func synchronize(_ items: [ToDoItem], queue: DispatchQueue,
                     completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        merge(newItems: items, queue: itemsQueue) { [weak self] idsToDelete, dirties in
            self?.networkingService.putAll(addOrUpdateItems: dirties, deleteIds: idsToDelete) { result in
                switch result {
                case .failure(_):
                    queue.async {
                        completion(result)
                    }
                case let .success(items):
                    self?.items = items
                    self?.fileCacheService.clearTombstones { _ in}
                    queue.async {
                        completion(.success(items))
                    }
                }
            }
        }
    }
    func needToSynchronize() -> Bool {
        return fileCacheService.dirties.count != 0 || fileCacheService.tombstones.count != 0
    }
}
