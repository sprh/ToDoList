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
    }
    func getToDoItem(id: String) -> ToDoItem? {
        return items.first(where: {$0.id == id})
    }
    func getToDoItems(withDone: Bool) -> [ToDoItem] {
        return itemsQueue.sync {
            (!withDone ? items.filter({!$0.done}) : items).sorted(by: {$0.createdAt < $1.createdAt})
        }
    }
    func update(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<Void, Error>) -> Void) {
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
                self?.replaceAndSave(item: dirtyItem, queue: queue, completion: completion)
                queue.async {
                    completion(.failure(error))
                }
            }
        }
    }
    func delete(_ id: String, queue: DispatchQueue, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let index = items.firstIndex(where: {$0.id == id}) else {
            return
        }
        items.remove(at: index)
        networkingService.delete(id) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.fileCacheService.saveFile(items: self.items) { _ in
                    queue.async {
                        completion(.success(()))
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
    func create(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<Void, Error>) -> Void) {
        items.append(item)
        networkingService.create(item) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case let .success(item):
                self.replaceAndSave(item: item, queue: queue, completion: completion)
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
                self.replaceAndSave(item: dirtyItem, queue: queue, completion: completion)
            }
        }
    }
    func replaceAndSave(item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<Void, Error>) -> Void) {
        itemsQueue.async { [weak self] in
            guard let self = self,
                  let index = self.items.firstIndex(where: {$0.id == item.id}) else {
                queue.async {
                    completion(.success(()))
                }
                return
            }
            self.items[index] = item
            self.fileCacheService.saveFile(items: self.items) { result in
                queue.async {
                    completion(result)
                }
            }
        }
    }
    func merge(newItems: [ToDoItem], queue: DispatchQueue, completion: @escaping ([ToDoItem]) -> Void) {
        itemsQueue.async { [weak self] in
            guard let self = self else {return}
            let oldItems = self.items
            var items: [ToDoItem] = []
            for newItem in newItems {
                if let oldItem = oldItems.first(where: {$0.id == newItem.id}) {
                    if let oldUpdate = oldItem.updatedAt,
                       let newUpdate = newItem.updatedAt,
                       oldUpdate <= newUpdate {
                        items.append(newItem)
                    } else {
                        items.append(oldItem)
                    }
                } else {
                    items.append(newItem)
                }
            }
            self.items = items
            self.fileCacheService.saveFile(items: items) { _ in
                queue.async {
                    completion(items)
                }
            }
        }
    }
    func loadData(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        networkingService.getAll { [weak self] result in
            guard let self = self else {return}
            switch result {
            case let .success(items):
                queue.async {
                    completion(.success(items))
                }
            case .failure(_):
                self.loadFromFile(queue: queue, completion: completion)
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
    func synchronize(item: ToDoItem?, idToDelete: String?, queue: DispatchQueue,
                     completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        var dirties = fileCacheService.dirties
        var ids = fileCacheService.tombstones.map({$0.id})
        if let item = item {
            let dirtyItem = ToDoItem(id: item.id,
                                     text: item.text,
                                     importance: item.importance,
                                     deadline: item.deadline,
                                     color: item.color,
                                     done: item.done,
                                     updatedAt: item.updatedAt,
                                     createdAt: item.createdAt,
                                     isDirty: true)
            dirties.append(dirtyItem)
        }
        if let id = idToDelete {
            ids.append(id)
        }
        networkingService.putAll(addOrUpdateItems: dirties,
                                 deleteIds: ids) { [weak self] result in
            switch result {
            case let .failure(error):
                queue.async {
                    completion(.failure(error))
                }
            case let .success(items):
                self?.fileCacheService.clearTombstones()
                self?.fileCacheService.reloadItems(items: items)
                self?.items = items
                queue.async {
                    completion(.success(items))
                }
            }
        }
    }
    func needToSynchronize() -> Bool {
        return fileCacheService.dirties.count != 0 || fileCacheService.tombstones.count != 0
    }
}
