//
//  NetworkProtocol.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import Foundation

protocol NetworkProtocol {
    func getToDoItems(completion: @escaping (NetworkResult<[ToDoItem]>) -> Void)
    func deleteToDoItem(id: String, completion: @escaping (NetworkResult<ToDoItem>) -> Void)
    func addToDoItem(toDoItem: ToDoItem, completion: @escaping (NetworkResult<ToDoItem>) -> Void)
    func getToDoItem(toDoItem: ToDoItem, completion: @escaping (NetworkResult<ToDoItem>) -> Void)
}
