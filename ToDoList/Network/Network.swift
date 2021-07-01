//
//  Network.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import Foundation

class Network: NetworkProtocol {
    func getToDoItems(completion: @escaping (NetworkResult<[ToDoItem]>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            completion(.success([]))
        }
    }
    func deleteToDoItem(id: String, completion: @escaping (NetworkResult<ToDoItem>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            completion(.success(ToDoItem()))
        }
    }
    func addToDoItem(toDoItem: ToDoItem, completion: @escaping (NetworkResult<ToDoItem>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            completion(.success(toDoItem))
        }
    }
    func getToDoItem(toDoItem: ToDoItem, completion: @escaping (NetworkResult<ToDoItem>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            completion(.success(toDoItem))
        }
    }
}
