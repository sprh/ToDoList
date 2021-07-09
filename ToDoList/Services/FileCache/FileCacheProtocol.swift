//
//  FileCacheProtocol.swift
//  ToDoList
//
//  Created by Софья Тимохина on 09.07.2021.
//

import Foundation
import Models

protocol FileCacheProtocol {
    func getAll(completion: @escaping ([ToDoItem]?) -> Void)
    func create(_ item: ToDoItem, completion: @escaping (ToDoItem?) -> Void)
    func create(_ item: Tombstone, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    func update(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    func delete(_ item: Tombstone, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    func delete(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    // TODO: Update and delete several items. <- Like merge
}
