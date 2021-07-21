//
//  ToDoProtocol.swift
//  ToDoList
//
//  Created by Софья Тимохина on 02.07.2021.
//

import Foundation
import Models

protocol ToDoServiceProtocol {
    func update(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    func delete(_ id: String, queue: DispatchQueue, completion: @escaping (Result<String, Error>) -> Void)
    func create(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping (Result<ToDoItem, Error>) -> Void)
    func getToDoItem(id: String) -> ToDoItem?
    func getToDoItems(withDone: Bool) -> [ToDoItem]
    func merge(addedItems: [ToDoItem],
               oldItems: [ToDoItem],
               queue: DispatchQueue,
               completion: @escaping ([ToDoItem]) -> Void)
    func loadData(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    func loadFromDataBase(queue: DispatchQueue, completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    func synchronize(_ items: [ToDoItem], queue: DispatchQueue,
                     completion: @escaping (Result<[ToDoItem], Error>) -> Void)
    func needToSynchronize() -> Bool
}
