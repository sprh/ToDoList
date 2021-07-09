//
//  ToDoViewControllerItemsWork.swift
//  ToDoList
//
//  Created by Софья Тимохина on 11.06.2021.
//

import Foundation
import Models

extension ToDoViewController: NewToDoDelegate {
    public func getToDoItem(at index: Int, doneShown: Bool) -> ToDoItem {
        return index >= items.count ? ToDoItem() : items[index]
    }
    public func toDoItemsCount() -> Int {
        return items.count
    }
    public func updateToDoItem(toDoItem: ToDoItem, indexPath: IndexPath) {
        guard let index = allItems.firstIndex(where: {$0.id == toDoItem.id}) else { return }
        allItems[index] = toDoItem
        toDoService.update(toDoItem, queue: .main) { [weak self] _ in
            self?.tableViewReloadOldCell(at: indexPath)
        }
    }
    public func updateToDoItemDone(id: String, indexPath: IndexPath) {
        guard let index = allItems.firstIndex(where: {$0.id == id}) else { return }
        let item = allItems[index]
        let newItem = ToDoItem(id: id,
                               text: item.text,
                               importance: item.importance,
                               deadline: item.deadline,
                               color: item.color,
                               done: !item.done,
                               updatedAt: Int(Date().timeIntervalSince1970))
        allItems[index] = newItem
        showLabelSetText()
        if newItem.done, !doneShown {
            tableViewDeleteOldCell(at: indexPath)
            toDoService.update(newItem, queue: .main) { _ in
            }
        } else if toDoService.needToSynchronize() {
            synchronize(toDoItem: newItem, idToDelete: nil)
        } else {
            updateToDoItem(toDoItem: newItem, indexPath: indexPath)
        }
    }
    public func deleteToDoItem(id: String, indexPath: IndexPath) {
        guard let index = allItems.firstIndex(where: {$0.id == id}) else { return }
        allItems.remove(at: index)
        showLabelSetText()
        tableViewDeleteOldCell(at: indexPath)
        toDoService.delete(id, queue: .main) { _ in
        }
        if toDoService.needToSynchronize() {
            synchronize(toDoItem: nil, idToDelete: id)
        }
    }
    public func addToDoItem(toDoItem: ToDoItem) {
        allItems.append(toDoItem)
        if toDoService.needToSynchronize() {
            synchronize(toDoItem: toDoItem, idToDelete: nil)
        } else {
            tableViewAddNew()
            toDoService.create(toDoItem, queue: .main) { _ in
            }
        }
    }
    public func getDoneItemsCount() -> Int {
        return allItems.filter({$0.done}).count
    }
    func loadData() {
        toDoService.loadData(queue: .main) { [weak self] result in
            switch result {
            case .failure(_):
                break
            case let .success(items):
                self?.toDoService.merge(newItems: items, queue: .main) { result in
                    self?.allItems = result
                    self?.tableView.reloadData()
                }
            }
        }
    }
    func synchronize(toDoItem: ToDoItem?, idToDelete: String?) {
        toDoService.synchronize(item: toDoItem, idToDelete: idToDelete, queue: .main) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(_):
                break
            case .success(_):
                self.toDoService.merge(newItems: self.items, queue: .main) { result in
                    self.allItems = result
                    self.tableView.reloadData()
                }
            }
        }
    }
}
