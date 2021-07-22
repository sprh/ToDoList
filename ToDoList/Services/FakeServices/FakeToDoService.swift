//
//  FakeToDoService.swift
//  ToDoListTests
//
//  Created by Софья Тимохина on 21.07.2021.
//

import Models

class FakeToDoService: ToDoServiceProtocol {
    var fileCacheService: FileCacheServiceProtocol
    var networkingService: NetworkingService
    
    init(fileCacheService: FileCacheServiceProtocol, networkingService: NetworkingService) {
        self.fileCacheService = fileCacheService
        self.networkingService = networkingService
    }
    
    func update(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
    
    func delete(_ id: String, queue: DispatchQueue, completion: @escaping (Result<String, Error>) -> Void) {
    }
    
    func create(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
    
    func getToDoItem(id: String) -> ToDoItem? {
        return nil
    }
    
    func getToDoItems(withDone: Bool) -> [ToDoItem] {
        return []
    }
    
    func merge(addedItems: [ToDoItem], oldItems: [ToDoItem], queue: DispatchQueue,
               completion: @escaping ([ToDoItem]) -> Void) {
    }
    
    func loadData(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
    }
    
    func loadFromDataBase(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
    }
    
    func synchronize(_ items: [ToDoItem], queue: DispatchQueue,
                     completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
    }
    
    func needToSynchronize() -> Bool {
        return false
    }
    
    private func getRandomString() {
        let length = 32
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomCharacters = (0..<length).map{_ in characters.randomElement()!}
        let randomString = String(randomCharacters)
    }
}
