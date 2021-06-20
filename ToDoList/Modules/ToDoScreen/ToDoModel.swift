//
//  ToDoModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 11.06.2021.
//

import Foundation

class ToDoModel {
    let fileCache = FileCache()
    public func getToDoItem(at index: Int) -> ToDoItem {
        return fileCache.toDoItems[index]
    }
    public func toDoItemsCount() -> Int {
        return fileCache.toDoItems.count
    }
    public func doneToDoItems() -> [ToDoItem] {
        return fileCache.toDoItems.compactMap({ $0.done ? $0 : nil})
    }
    public func doneToDoItemsCount() -> Int {
        return doneToDoItems().count
    }
    public func updateToDoItemDone(id: String) {
        guard let item = fileCache.get(with: id) else { return }
        let newItem = ToDoItem(id: id, text: item.text, importance: item.importance,
                               deadline: item.deadline, color: item.color, done: !item.done)
        fileCache.add(item: newItem)
    }
    public func deleteToDoItem(id: String) {
        fileCache.delete(with: id)
    }
}
