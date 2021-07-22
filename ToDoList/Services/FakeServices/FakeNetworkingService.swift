//
//  FakeNetworkingService.swift
//  ToDoListTests
//
//  Created by Софья Тимохина on 21.07.2021.
//

import Models

class FakeNetworkingService: NetworkingService {
    func getAll(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        completion(.success([ToDoItem(text: "Fake item", updatedAt: nil)]))
    }
    
    func create(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
    
    func update(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
    
    func delete(_ id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
    
    func putAll(addOrUpdateItems: [ToDoItem], deleteIds: [String],
                completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
    }
}
