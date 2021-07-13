//
//  ItemsListModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import Foundation
import Models

public class ItemsListModel {
    let toDoService: ToDoService!
    var allItems: [ToDoItem] = []
    var doneShown: Bool = false
    var indexPath: IndexPath?
    var items: [ToDoItem] {
        !doneShown ? allItems.filter({!$0.done}): allItems
    }
    var doneItemsCount: Int {
        allItems.filter({$0.done}).count
    }

    init(toDoService: ToDoService) {
        self.toDoService = toDoService
    }

    func getItem(at index: Int) -> ToDoItem {
        return items.count <= index ? ToDoItem() : items[index]
    }
}
