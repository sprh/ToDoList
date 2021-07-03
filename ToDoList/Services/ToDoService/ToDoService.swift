//
//  ToDoService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 02.07.2021.
//

import Foundation

class ToDoService {
    let fileCache: FileCache
    let networkingService: DefaultNetworkingService
    private let itemsQueue = DispatchQueue(label: "ToDOSerbice", attributes: [.concurrent])
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
    func update(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        fileCache.add(item: item)
        networkingService.update(item) { [weak self] result in
            switch result {
            case let .success(item):
                self?.replaceAndSave(item: item, queue: queue, completion: completion)
            case let .failure(error):
                queue.async {
                    completion(.failure(error))
                }
            }
        }
    }
    func delete(_ id: String, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        fileCache.delete(with: id)
        networkingService.delete(id) { [weak self] result in
            switch result {
            case let .success(item):
                completion(.success(item))
            case let .failure(error):
                self?.fileCache.addTombstone(tombstone: Tombstone(id: id))
                completion(.failure(error))
            }
        }
    }
    func create(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        fileCache.add(item: item)
        networkingService.create(item) { [weak self] result in
            switch result {
            case let .success(item):
                self?.replaceAndSave(item: item, queue: queue, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    func replaceAndSave(item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        replace(item: item) { [weak self] in
            self?.fileCache.saveFile {result in
                switch result {
                case let .failure(error):
                    queue.async {
                        completion(.failure(error))
                    }
                case .success():
                    queue.async {
                        completion(.success(item))
                    }
                }
            }
        }
    }
    func merge(items: [ToDoItem], completion: @escaping () -> Void) {
        fileCache.reloadItems(toDoItems: items, completion: completion)
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
    func loadItems(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        networkingService.getAll { [weak self] result in
            switch result {
            case let .success(items):
                self?.merge(items: items) {
                    queue.async {
                        completion(.success(items))
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
}
