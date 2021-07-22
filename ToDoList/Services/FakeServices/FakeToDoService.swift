//
//  FakeToDoService.swift
//  ToDoListTests
//
//  Created by Софья Тимохина on 21.07.2021.
//

import Models

class FakeToDoService: ToDoServiceProtocol {
    var toDoItems: [ToDoItem] = [ToDoItem(text: "1", done: false, createdAt:                                          Int(Date().timeIntervalSince1970)),
                                 ToDoItem(text: "2", done: false, createdAt: Int(Date().timeIntervalSince1970)),
                                 ToDoItem(text: "3", done: false, createdAt: Int(Date().timeIntervalSince1970)),
                                 ToDoItem(text: "4", done: false, createdAt: Int(Date().timeIntervalSince1970)),
                                 ToDoItem(text: "5", done: false, createdAt: Int(Date().timeIntervalSince1970))]
//    var fileCacheService: FileCacheServiceProtocol
//    var networkingService: NetworkingService
//
//    init(fileCacheService: FileCacheServiceProtocol, networkingService: NetworkingService) {
//        self.fileCacheService = fileCacheService
//        self.networkingService = networkingService
//    }
//
    func update(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        guard let index = toDoItems.firstIndex(where: {$0.id == item.id}) else {
            completion(.failure(NetworkError.notFound)); return
        }
        toDoItems[index] = item
        completion(.success(item))
    }
    
    func delete(_ id: String, queue: DispatchQueue, completion: @escaping (Result<String, Error>) -> Void) {
        guard let index = toDoItems.firstIndex(where: {$0.id == id}) else {
            completion(.failure(NetworkError.notFound)); return
        }
        toDoItems.remove(at: index)
    }
    
    func create(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        toDoItems.append(item)
    }
    
    func getToDoItem(id: String) -> ToDoItem? {
        return toDoItems.first(where: {$0.id == id})
    }
    
    func getToDoItems(withDone: Bool) -> [ToDoItem] {
        return toDoItems
    }
    
    func merge(addedItems: [ToDoItem], oldItems: [ToDoItem], queue: DispatchQueue,
               completion: @escaping ([ToDoItem]) -> Void) {
        completion(toDoItems)
    }
    
    func loadData(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        completion(.success(toDoItems))
    }
    
    func loadFromDataBase(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        completion(.success(toDoItems))
        
    }
    
    func synchronize(_ items: [ToDoItem], queue: DispatchQueue,
                     completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        completion(.success(toDoItems))
    }
    
    func needToSynchronize() -> Bool {
        return false
    }
//    
//    private func getRandomString() {
//        let length = 32
//        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        let randomCharacters = (0..<length).map{_ in characters.randomElement()!}
//        let randomString = String(randomCharacters)
//    }
}
