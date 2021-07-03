//
//  ToDoModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 11.06.2021.
//

import Foundation

class ToDoModel {
    let toDoService: ToDoService
    public init(toDoService: ToDoService) {
        self.toDoService = toDoService
    }
    public func getToDoItem(at index: Int, doneShown: Bool) -> ToDoItem {
        let toDoItems = toDoService.getToDoItems(withDone: doneShown)
        return index >= toDoItems.count ? ToDoItem() : toDoItems[index]
    }
    public func toDoItemsCount(doneShown: Bool) -> Int {
        return toDoService.getToDoItems(withDone: doneShown).count
    }
    public func updateToDoItemDone(id: String) {
        guard let item = toDoService.getToDoItem(id: id) else { return }
        let newItem = ToDoItem(id: id,
                               text: item.text,
                               importance: item.importance,
                               deadline: item.deadline,
                               color: item.color,
                               done: !item.done,
                               updatedAt: Int(Date().timeIntervalSince1970))
        toDoService.update(newItem, queue: .main) { _ in
        }
    }
    public func deleteToDoItem(id: String) {
        toDoService.delete(id, queue: .main) { [weak self] _ in
        }
    }
    public func addToDoItem(toDoItem: ToDoItem) {
        toDoService.create(toDoItem, queue: .main) { _ in
        }
    }
    public func getDoneItemsCount() -> Int {
        return toDoService.getToDoItems(withDone: true).filter({$0.done}).count
    }
    public func loadData(completion: @escaping () -> Void) {
        toDoService.loadFromFile(queue: .main) {_ in
            completion()
        }
    }
    public func loadFromServer(completion: @escaping () -> Void) {
        toDoService.loadFromServer(queue: .main) { _ in
            completion()
        }
    }
}
