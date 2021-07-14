//
//  NewItemsModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import Foundation
import Models

final class NewItemModel {
    let toDoItem: ToDoItem!
    let indexPath: IndexPath?
    
    init(_ toDoItem: ToDoItem, indexPath: IndexPath?) {
        self.toDoItem = toDoItem
        self.indexPath = indexPath
    }
}
