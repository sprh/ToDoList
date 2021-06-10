//
//  FileCache.swift
//  ToDoList
//
//  Created by Софья Тимохина on 09.06.2021.
//

import Foundation

class FileCache {
    private(set) var toDoItems: [ToDoItem] = []
    func add(item toDoItem: ToDoItem) {
        toDoItems.append(toDoItem)
    }
    func delete(with id: String) {
        guard let index = toDoItems.firstIndex(where: {$0.id == id}) else {
            return
        }
        toDoItems.remove(at: index)
    }
}
