//
//  FileCacheServiceProtocol.swift
//  ToDoList
//
//  Created by Софья Тимохина on 01.07.2021.
//

import UIKit
import Models

protocol FileCacheServiceProtocol {
    func saveFile(items: [ToDoItem], fileName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func loadFile(fileName: String, completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    func getTombstones(completion: @escaping (Result<[Tombstone], Error>) -> Void)
    func create(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    func create(_ item: Tombstone, completion: @escaping (Result<Tombstone, Error>) -> Void)
    func update(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    func delete(_ item: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void)
}
