//
//  ToDoModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 11.06.2021.
//

import Foundation

class ToDoModel {
    let toDoItems: [ToDoItem] = [ToDoItem(text: "Купить сыр", color: "", done: false),
                                 ToDoItem(text: "Купить сыр, color: ", color: "", done: true),
                                 ToDoItem(text: "Купить сыр, color: ", color: "", done: false),
                                 ToDoItem(text: "Купить сыр", color: "", done: true),
                                 ToDoItem(id: "", text: "Купить сыр", importance: .important,
                                          deadline: nil, color: "", done: false),
                                 ToDoItem(id: "", text: "Купить что-то, где-то, зачем-то, но зачем?", importance: .important, deadline: nil, color: "", done: true),
                                 ToDoItem(id: "", text: "Купить что-то, где-то, зачем-то, но зачем?", importance: .important, deadline: nil, color: "", done: true)]
    public func getToDoItem(at index: Int) -> ToDoItem {
        return toDoItems[index]
    }
    public func toDoItemsCount() -> Int {
        return toDoItems.count
    }
}
