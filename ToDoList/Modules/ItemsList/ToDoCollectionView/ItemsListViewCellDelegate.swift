//
//  ItemsListViewCellDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import Foundation
import Models

protocol ItemsListPresenterDelegate: AnyObject {
    func addItem(_ item: ToDoItem)
    func updateItem(_ item: ToDoItem, at indexPath: IndexPath)
    func updateItemDone(_ item: ToDoItem, at indexPath: IndexPath)
    func deleteItem(_ id: String, at indexPath: IndexPath)
}
