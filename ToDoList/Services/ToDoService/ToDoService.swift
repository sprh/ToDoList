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
    func delete(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        networkingService.delete(item.id) { [weak self] result in
            switch result {
            case let .success(item):
                completion(.success(item))
            case let .failure(error):
                self?.fileCache.addTombstone(tombstone: Tombstone(id: item.id))
                completion(.failure(error))
            }
        }
    }
    func create(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        fileCache.add(item: item)
        networkingService.delete(item.id) { [weak self] result in
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
                    completion(.success(item))
                }
            }
        }
    }
    func replace(item: ToDoItem, completion: @escaping () -> Void) {
        itemsQueue.async(flags: [.barrier]) { [weak self] in
            guard let self = self else {return}
            self.fileCache.add(item: item)
        }
        completion()
    }
}
