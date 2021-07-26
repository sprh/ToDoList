//
//  NetworkingService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import Foundation
import Models

//  sourcery: AutoMockable
public protocol NetworkingService {
    /// Get all to do items.
    func getAll(completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    /// Add a new to do item.
    func create(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    /// Update a to do item.
    func update(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    /// Delete a to do item.
    func delete(_ id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    /// Update, add or delete several to do items.
    func putAll(addOrUpdateItems: [ToDoItem], deleteIds: [String],
                completion: @escaping (Result<[ToDoItem], Error>) -> Void)
}
