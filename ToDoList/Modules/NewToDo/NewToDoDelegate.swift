//
//  NewToDoDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 25.06.2021.
//

import Foundation

protocol NewToDoDelegate: AnyObject {
    func deleteToDoItem(id: String, index: IndexPath)
    func updateToDoItem(toDoItem: ToDoItem, indexPath: IndexPath)
    func addToDoItem(toDoItem: ToDoItem)
}
