//
//  FakeFileCacheService.swift
//  ToDoListTests
//
//  Created by Софья Тимохина on 21.07.2021.
//

import Models

final class FakeFileCacheService: FileCacheServiceProtocol {
    var dirties: [ToDoItem] {
        return []
    }
    var tombstones: [Tombstone] {
        return []
    }
    
    func save(items: [ToDoItem], completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
    }
    
    func load(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        completion(.success([ToDoItem(text: "Fake item", updatedAt: nil)]))
    }
    
    func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
    }
    
    func getTombstones(completion: @escaping (Result<[Tombstone], Error>) -> Void) {
    }
    
    func create(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
    
    func create(_ item: Tombstone, completion: @escaping (Result<Tombstone, Error>) -> Void) {
    }
    
    func update(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
    
    func deleteToDoItem(_ id: String, completion: @escaping (Result<String, Error>) -> Void) {
    }
    
    func deleteTombstone(_ id: String, completion: @escaping (Result<String, Error>) -> Void) {
    }
    
    func addTombstone(tombstone: Tombstone, completion: @escaping (Result<Tombstone, Error>) -> Void) {
    }
    
    func clearTombstones(completion: @escaping (Result<Void, Error>) -> Void) {
    }
    
    func reloadItems(items: [ToDoItem]) {
    }
}
