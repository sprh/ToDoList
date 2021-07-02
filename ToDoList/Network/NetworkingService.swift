//
//  NetworkingService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import Foundation

protocol NetworkingService {
    /// Get all to do items.
    func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    /// Add a new to do item.
    func postToDoItem(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    /// Update a to do item.
    func putToDoItem(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    /// Delete a to do item.
    func deleteToDoItem(id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    /// Update, add or delete several to do items.
    func putToDoItems(addOrUpdateItems: [ToDoItem], deleteIds: [String],
                      completion: @escaping (Result<ToDoItem, Error>) -> Void)
}
