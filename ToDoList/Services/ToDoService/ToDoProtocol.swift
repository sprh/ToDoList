//
//  ToDoProtocol.swift
//  ToDoList
//
//  Created by Софья Тимохина on 02.07.2021.
//

import Foundation
import Models

protocol ToDoProtocol {
    func create(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping () -> Void)
    func update(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping () -> Void)
    func delete(_ item: ToDoItem, queue: DispatchQueue, completion: @escaping () -> Void)
}
