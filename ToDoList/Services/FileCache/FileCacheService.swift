//
//  FileCacheService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 01.07.2021.
//

import Foundation
import Models

final class FileCacheService: FileCacheServiceProtocol {
    let queue = DispatchQueue(label: "FileCacheQueue")
    private(set) var fileCache: FileCache!

    public init(fileCache: FileCache) {
        self.fileCache = fileCache
    }
    
    func save(items: [ToDoItem],
              completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        queue.async { [weak self] in
            do {
                try self?.fileCache.clearTombstones()
                try self?.fileCache.save(items) { items in
                    completion(.success(items))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func load(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.fileCache.load()
                completion(.success(self.fileCache.toDoItems))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func addTombstone(tombstone: Tombstone, completion: @escaping (Result<Tombstone, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.fileCache.create(tombstone)
                try self.fileCache.deleteToDoItem(tombstone.id)
                completion(.success(tombstone))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func clearTombstones(completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else {return}
            do {
                try self.fileCache.clearTombstones()
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    var dirties: [ToDoItem] {
        return fileCache.toDoItems.filter({$0.isDirty})
    }
    
    var tombstones: [Tombstone] {
        return fileCache.tombstones
    }
    
    func reloadItems(items: [ToDoItem]) {
        fileCache.reloadItems(items)
    }
    
    func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.fileCache.getItems { items in
                    completion(.success(items))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func getTombstones(completion: @escaping (Result<[Tombstone], Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.fileCache.getTombstones { tombstones in
                    completion(.success(tombstones))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func create(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.fileCache.create(item)
                completion(.success(item))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func create(_ item: Tombstone, completion: @escaping (Result<Tombstone, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.fileCache.create(item)
                completion(.success(item))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func update(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.fileCache.update(item)
                completion(.success(item))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func deleteToDoItem(_ id: String, completion: @escaping (Result<String, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.fileCache.deleteToDoItem(id)
                completion(.success(id))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func deleteTombstone(_ id: String, completion: @escaping (Result<String, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.fileCache.deleteTombstone(id)
                completion(.success(id))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}
