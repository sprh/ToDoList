//
//  NetworkProtocol.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import Foundation

protocol NetworkProtocol {
    func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    func deleteToDoItem(id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    func addToDoItem(toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    func getToDoItem(toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
}
