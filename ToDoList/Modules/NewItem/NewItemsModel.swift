//
//  NewItemsModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import Foundation
import Models

final class NewItemModel {
    let toDoItem: ToDoItem?
    let indexPath: IndexPath?
    var standartColor: Bool = false
    var datePickerShown = false
    let importanceAsArray = ["low", "basic", "important"]
    var itemIsNew: Bool {
        toDoItem == nil
    }
    init(_ toDoItem: ToDoItem?, indexPath: IndexPath?) {
        self.toDoItem = toDoItem
        self.indexPath = indexPath
    }
    
    func areThereAnyDifferences(text: String, color: String?, deadline: Int?, importanceIndex: Int) -> Bool {
        guard let toDoItem = toDoItem else { return true }
        return toDoItem.text != text ||
            toDoItem.color != color ||
            toDoItem.deadline != deadline ||
            toDoItem.importance != Importance.init(rawValue: importanceAsArray[importanceIndex])
    }
    func updateItem(text: String, importanceIndex: Int, deadline: Int?, color: String?) -> ToDoItem {
        guard let toDoItem = toDoItem else {
            return ToDoItem(text: text,
                            importance: Importance.init(rawValue: importanceAsArray[importanceIndex]),
                            deadline: deadline,
                            color: color,
                            updatedAt: nil,
                            createdAt: (Int)(Date().timeIntervalSince1970))
        }
        return ToDoItem(id: toDoItem.id,
                        text: text,
                        importance: Importance.init(rawValue: importanceAsArray[importanceIndex]),
                        deadline: deadline,
                        color: color,
                        done: toDoItem.done,
                        updatedAt: (Int)(Date().timeIntervalSince1970),
                        createdAt: toDoItem.createdAt,
                        isDirty: toDoItem.isDirty)
    }
}
