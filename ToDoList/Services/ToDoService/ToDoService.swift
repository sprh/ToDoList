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
        loadFromDataBase(queue: itemsQueue) { result in
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
                let dirtyItem = item.markAsDirty()
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
                let dirtyItem = item.markAsDirty()
                self.items.append(dirtyItem)
                self.fileCacheService.create(dirtyItem, completion: completion)
            }
        }
    }
    func merge(addedItems: [ToDoItem],
               oldItems: [ToDoItem],
               queue: DispatchQueue,
               completion: @escaping ([ToDoItem]) -> Void) {
        var resultItems: [ToDoItem] = []
        var deletedItems: [String] = []
        var addedOrUpdatedItems: [ToDoItem] = []
        let tombstones = fileCacheService.tombstones.map({$0.id})
        for item in addedItems {
            if let oldItem = oldItems.first(where: {$0.id == item.id}) {
                if let oldUpdate = oldItem.updatedAt,
                   let addedUpdate = item.updatedAt,
                   oldUpdate >= addedUpdate {
                    resultItems.append(oldItem)
                } else {
                    resultItems.append(item)
                    addedOrUpdatedItems.append(item)
                }
            } else {
                resultItems.append(item)
                addedOrUpdatedItems.append(item)
            }
        }
        for oldItem in oldItems {
            if tombstones.contains(oldItem.id) {
                deletedItems.append(oldItem.id)
            } else if !resultItems.contains(where: {$0.id == oldItem.id}) {
                resultItems.append(oldItem)
            }
        }
        networkingService.putAll(addOrUpdateItems: addedOrUpdatedItems, deleteIds: deletedItems) { [weak self] result in
            switch result {
            case .failure(_):
                queue.async {
                    completion(resultItems)
                }
            case let .success(items):
                self?.fileCacheService.save(items: items) { _ in }
                queue.async {
                    completion(items)
                }
            }
        }
    }
    func loadData(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        networkingService.getAll { result in
            switch result {
            case .success(_):
                queue.async {
                    completion(result)
                }
            case .failure(_):
                queue.async {
                    completion(result)
                }
            }
        }
    }
    func loadFromDataBase(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        fileCacheService.load { [weak self] result in
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
        networkingService.getAll { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(_):
                queue.async {
                    completion(result)
                }
            case let .success(networkItems):
                self.merge(addedItems: items, oldItems: networkItems, queue: self.itemsQueue) { mergedItems in
                    queue.async {
                        completion(.success(mergedItems))
                    }
                }
            }
        }
    }
    func needToSynchronize() -> Bool {
        return fileCacheService.dirties.count != 0 || fileCacheService.tombstones.count != 0
    }
}
