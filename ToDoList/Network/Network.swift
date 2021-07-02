//
//  Network.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import Foundation

class Network: NetworkProtocol {
    let queue = DispatchQueue(label: "com.ToDoList.NetworkQueue")
    func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        queue.async {
            sleep(1)
            completion(.success([]))
        }
    }
    func deleteToDoItem(id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        queue.async {
            sleep(1)
            completion(.success(ToDoItem()))
        }
    }
    func addToDoItem(toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        queue.async {
            sleep(1)
            completion(.success(toDoItem))
        }
    }
    func getToDoItem(toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        queue.async {
            sleep(1)
            completion(.success(toDoItem))
        }
    }
}
