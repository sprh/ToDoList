//
//  NewToDoModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 12.06.2021.
//

import Foundation

class NewToDoModel {
    private(set) var toDoItem: ToDoItem!
    private(set) var fileCache: FileCache!
    public init(toDoItem: ToDoItem, fileCache: FileCache) {
        self.toDoItem = toDoItem
        self.fileCache = fileCache
    }
    func save(id: String? = nil, text: String, importance: String, deadline: Date?, color: String) {
        // I think I don't need to save it now, because we haven't got a data base and
        // a field with all to do items in the FileCache isn't a static.
        let newToDoItem = ToDoItem(id: id, text: text,
                                   importance: Importance.init(rawValue: importance), deadline:
                                    deadline, color: color, done: false)
        fileCache.add(item: newToDoItem)
    }
    func delete() {
        fileCache.delete(with: toDoItem.id)
    }
}
