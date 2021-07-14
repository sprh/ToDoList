//
//  ItemsListViewCellDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import Foundation
import Models

protocol ItemsListViewCellDelegate: AnyObject {
    func addItem(_ item: ToDoItem)
    func updateItem(_ item: ToDoItem, indexPath: IndexPath)
    func deleteItem(_ id: String, indexPath: IndexPath)
}
