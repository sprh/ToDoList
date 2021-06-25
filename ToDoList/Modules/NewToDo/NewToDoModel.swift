//
//  NewToDoModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 12.06.2021.
//

import Foundation

final class NewToDoModel {
    private(set) var toDoItem: ToDoItem!
    private(set) var fileCache: FileCache!
    weak var delegate: NewToDoDelegate?
    private(set) var indexPath: IndexPath?
    public init(toDoItem: ToDoItem, fileCache: FileCache, indexPath: IndexPath?) {
        self.toDoItem = toDoItem
        self.fileCache = fileCache
        self.indexPath = indexPath
    }
    func save(text: String, importance: String, deadline: Date?, color: String) {
        let newToDoItem = ToDoItem(id: toDoItem.id, text: text,
                                   importance: Importance.init(rawValue: importance), deadline:
                                    deadline, color: color, done: toDoItem.done)
        toDoItem = newToDoItem
        fileCache.add(item: newToDoItem)
        guard let indexPath = self.indexPath else {
            delegate?.add()
            return
        }
        delegate?.update(indexPath: indexPath)
    }
    func delete() {
        fileCache.delete(with: toDoItem.id)
        guard let indexPath = self.indexPath else { return }
        delegate?.delete(indexPath: indexPath)
    }
}
