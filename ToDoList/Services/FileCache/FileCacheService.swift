//
//  FileCacheService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 01.07.2021.
//

import Foundation
import Models

class FileCacheService: FileCacheServiceProtocol {
    let queue = DispatchQueue(label: "com.ToDoList.FileCacheQueue")
    let fileCache = FileCache()
    public init() {
    }
    func saveFile(items: [ToDoItem], fileName: String = "todoitems.json",
                  completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            self?.fileCache.saveFile(items, to: fileName) { _ in
            }
        }
    }
    func loadFile(fileName: String = "todoitems.json",
                  completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        queue.async { [weak self] in
            self?.fileCache.loadFile(from: fileName) { _ in
            }
        }
    }
    func addTombstone(tombstone: Tombstone, completion: @escaping (Result<Tombstone, Error>) -> Void) {
        do {
            try fileCache.create(tombstone)
        } catch {
        }
    }
    func clearTombstones() {
        fileCache.clearTombstones()
    }
    var dirties: [ToDoItem] {
        return fileCache.toDoItems.filter({$0.isDirty})
    }
    var tombstones: [Tombstone] {
        return fileCache.tombstones
    }
    func reloadItems(items: [ToDoItem]) {
        fileCache.reloadItems(toDoItems: items)
    }
    func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.fileCache.getToDoItems()
                completion(.success(self.fileCache.toDoItems))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    func getTombstones(completion: @escaping (Result<[Tombstone], Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
        }
    }
    func create(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
        }
    }
    
    func create(_ item: Tombstone, completion: @escaping (Result<Tombstone, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
        }
    }
    func update(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
        }
    }
    
    func delete(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
        }
    }
}
