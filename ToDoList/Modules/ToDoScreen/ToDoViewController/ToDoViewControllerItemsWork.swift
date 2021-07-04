//
//  ToDoViewControllerItemsWork.swift
//  ToDoList
//
//  Created by Софья Тимохина on 11.06.2021.
//

import Foundation

extension ToDoViewController: NewToDoDelegate {
    public func getToDoItem(at index: Int, doneShown: Bool) -> ToDoItem {
        return index >= items.count ? ToDoItem() : items[index]
    }
    public func toDoItemsCount() -> Int {
        return items.count
    }
    public func updateToDoItem(toDoItem: ToDoItem, indexPath: IndexPath) {
        toDoService.update(toDoItem, queue: .main) { [weak self] _ in
            self?.tableViewReloadOldCell(at: indexPath)
        }
    }
    public func updateToDoItemDone(id: String, indexPath: IndexPath) {
        guard let index = items.firstIndex(where: {$0.id == id}) else { return }
        let item = items[index]
        let newItem = ToDoItem(id: id,
                               text: item.text,
                               importance: item.importance,
                               deadline: item.deadline,
                               color: item.color,
                               done: !item.done,
                               updatedAt: Int(Date().timeIntervalSince1970))
        items[index] = newItem
        updateToDoItem(toDoItem: newItem, indexPath: indexPath)
    }
    public func deleteToDoItem(id: String, indexPath: IndexPath) {
        guard let index = items.firstIndex(where: {$0.id == id}) else { return }
        items.remove(at: index)
        tableViewDeleteOldCell(at: indexPath)
        toDoService.delete(id, queue: .main) { _ in
        }
    }
    public func addToDoItem(toDoItem: ToDoItem) {
        items.append(toDoItem)
        tableViewAddNew()
        toDoService.create(toDoItem, queue: .main) { _ in
        }
    }
    public func getDoneItemsCount() -> Int {
        return items.filter({$0.done}).count
    }
    public func doneChanged(withDone: Bool) {
        items = toDoService.getToDoItems(withDone: withDone)
    }
}
