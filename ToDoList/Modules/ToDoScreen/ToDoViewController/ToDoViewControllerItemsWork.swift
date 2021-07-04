//
//  ToDoViewControllerItemsWork.swift
//  ToDoList
//
//  Created by Софья Тимохина on 11.06.2021.
//

import Foundation

extension ToDoViewController: NewToDoDelegate {
    public func getToDoItem(at index: Int, doneShown: Bool) -> ToDoItem {
        let toDoItems = toDoService.getToDoItems(withDone: doneShown)
        return index >= toDoItems.count ? ToDoItem() : toDoItems[index]
    }
    public func toDoItemsCount(doneShown: Bool) -> Int {
        return toDoService.getToDoItems(withDone: doneShown).count
    }
    public func updateToDoItem(toDoItem: ToDoItem, indexPath: IndexPath) {
        toDoService.update(toDoItem, queue: .main) { [weak self] _ in
            self?.tableViewReloadOldCell(at: indexPath)
        }
    }
    public func updateToDoItemDone(id: String, indexPath: IndexPath) {
        guard let item = toDoService.getToDoItem(id: id) else { return }
        let newItem = ToDoItem(id: id,
                               text: item.text,
                               importance: item.importance,
                               deadline: item.deadline,
                               color: item.color,
                               done: !item.done,
                               updatedAt: Int(Date().timeIntervalSince1970))
        updateToDoItem(toDoItem: newItem, indexPath: indexPath)
    }
    public func deleteToDoItem(id: String, index: IndexPath) {
        toDoService.delete(id, queue: .main) { [weak self] result in
            self?.tableViewDeleteOldCell(at: index)
        }
    }
    public func addToDoItem(toDoItem: ToDoItem) {
        toDoService.create(toDoItem, queue: .main) { [weak self] result in
            self?.tableViewAddNew()
        }
    }
    public func getDoneItemsCount() -> Int {
        return toDoService.getToDoItems(withDone: true).filter({$0.done}).count
    }
}
