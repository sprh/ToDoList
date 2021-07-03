//
//  NewToDoModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 12.06.2021.
//

import Foundation

final class NewToDoModel {
    private(set) var toDoItem: ToDoItem
    private(set) var toDoService: ToDoService
    weak var delegate: NewToDoDelegate?
    private(set) var indexPath: IndexPath?
    public init(toDoItem: ToDoItem, toDoService: ToDoService, indexPath: IndexPath?) {
        self.toDoItem = toDoItem
        self.toDoService = toDoService
        self.indexPath = indexPath
    }
    func save(text: String, importance: String, deadline: Date?, color: String) {
        let deadlineSince1970: Int? = (deadline != nil) ? Int(Date().timeIntervalSince(deadline!)) : nil
        let newToDoItem = ToDoItem(id: toDoItem.id,
                                   text: text,
                                   importance: Importance.init(rawValue: importance),
                                   deadline: deadlineSince1970,
                                   color: color,
                                   done: toDoItem.done,
                                   updatedAt: indexPath == nil ? nil: Int(Date().timeIntervalSince1970),
                                   createdAt: indexPath == nil ? Int(Date().timeIntervalSince1970) : toDoItem.createdAt)
        toDoItem = newToDoItem
        guard let indexPath = indexPath else {
            toDoService.create(newToDoItem, queue: .main) { [weak self] _ in
            }
            delegate?.add()
            return
        }
        toDoService.update(newToDoItem, queue: .main, completion: { [weak self] _ in
        })
        delegate?.update(indexPath: indexPath)
    }
    func delete() {
        guard let indexPath = indexPath else { return }
        delegate?.delete(indexPath: indexPath)
        toDoService.delete(toDoItem.id, queue: .main, completion: { [weak self] _ in
        })
    }
    var toDoItemIsNew: Bool {
        indexPath == nil
    }
}
