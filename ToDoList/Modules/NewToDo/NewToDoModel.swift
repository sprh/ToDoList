//
//  NewToDoModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 12.06.2021.
//

import Foundation
import Models

final class NewToDoModel {
    private(set) var toDoItem: ToDoItem
    weak var delegate: NewToDoDelegate?
    private(set) var indexPath: IndexPath?
    public init(toDoItem: ToDoItem, toDoService: ToDoService, indexPath: IndexPath?) {
        self.toDoItem = toDoItem
        self.indexPath = indexPath
    }
    func save(text: String, importance: String, deadline: Date?, color: String) {
        let deadlineSince1970: Int? = (deadline != nil) ? Int(deadline!.timeIntervalSince1970) : nil
        let newToDoItem = ToDoItem(id: toDoItem.id,
                                   text: text,
                                   importance: Importance.init(rawValue: importance),
                                   deadline: deadlineSince1970,
                                   color: color,
                                   done: toDoItem.done,
                                   updatedAt: indexPath == nil ? nil: Int(Date().timeIntervalSince1970),
                                   createdAt: indexPath == nil ? Int(Date().timeIntervalSince1970) : toDoItem.createdAt)
        guard let indexPath = indexPath else {
            delegate?.addToDoItem(toDoItem: newToDoItem)
            return
        }
        delegate?.updateToDoItem(toDoItem: newToDoItem, indexPath: indexPath)
    }
    func delete() {
        guard let indexPath = indexPath else { return }
        delegate?.deleteToDoItem(id: toDoItem.id, indexPath: indexPath)
    }
    var toDoItemIsNew: Bool {
        indexPath == nil
    }
}
