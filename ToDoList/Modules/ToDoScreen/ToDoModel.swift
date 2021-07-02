//
//  ToDoModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 11.06.2021.
//

import Foundation

class ToDoModel {
    let fileCache = FileCache()
    public func getToDoItem(at index: Int, doneShown: Bool) -> ToDoItem {
        if doneShown {
            return index >= fileCache.toDoItems.count ? ToDoItem() : fileCache.toDoItems[index]
        } else {
            return index >= notDoneToDoItems().count ? ToDoItem() : notDoneToDoItems()[index]
        }
    }
    public func toDoItemsCount() -> Int {
        return fileCache.toDoItems.count
    }
    public func notDoneToDoItems() -> [ToDoItem] {
        return fileCache.toDoItems.compactMap({ $0.done ? nil : $0})
    }
    public func notDoneToDoItemsCount() -> Int {
        return notDoneToDoItems().count
    }
    public func updateToDoItemDone(id: String) {
        guard let item = fileCache.get(with: id) else { return }
        let newItem = ToDoItem(id: id,
                               text: item.text,
                               importance: item.importance,
                               deadline: item.deadline,
                               color: item.color,
                               done: !item.done,
                               updatedAt: Int(Date().timeIntervalSince1970))
        fileCache.add(item: newItem)
    }
    public func deleteToDoItem(id: String) {
        fileCache.delete(with: id)
    }
    public func addToDoItem(toDoItem: ToDoItem) {
        fileCache.add(item: toDoItem)
    }
}
