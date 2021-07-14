//
//  ItemsListModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import Foundation
import Models

public class ItemsListModel {
    let toDoService: ToDoService!
    var allItems: [ToDoItem] = []
    var doneShown: Bool = false
    var items: [ToDoItem] {
        !doneShown ? allItems.filter({!$0.done}): allItems
    }
    var doneItemsCount: Int {
        allItems.filter({$0.done}).count
    }
    var needToSynchronize: Bool {
        return toDoService.needToSynchronize()
    }

    init(toDoService: ToDoService) {
        self.toDoService = toDoService
    }

    func getItem(at index: Int) -> ToDoItem {
        return items.count <= index ? ToDoItem() : items[index]
    }
    
    public func updateItem(_ item: ToDoItem) {
        guard let index = allItems.firstIndex(where: {$0.id == item.id}) else { return }
        allItems[index] = item
        toDoService.update(item, queue: .main) { _ in
        }
    }
    
    public func deleteItem(_ id: String) {
        guard let index = allItems.firstIndex(where: {$0.id == id}) else { return }
        allItems.remove(at: index)
        toDoService.delete(id, queue: .main) { _ in
        }
    }

    public func addItem(_ item: ToDoItem) {
        allItems.append(item)
        toDoService.create(item, queue: .main) { _ in
        }
    }
    
    func loadFromServer(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        toDoService.loadData(queue: .main, completion: completion)
    }

    func loadFromDataBase(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        toDoService.loadFromDataBase(queue: .main, completion: completion)
    }

    func synchronize(_ items: [ToDoItem], completion: @escaping (Result<Void, Error>) -> Void) {
        toDoService.synchronize(items, queue: .main) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(items):
                self.allItems = items
                completion(.success(()))
            }
        }
    }
    
    func merge(addedItems: [ToDoItem], oldItems: [ToDoItem],
               queue: DispatchQueue, completion: @escaping ([ToDoItem]) -> Void) {
        toDoService.merge(addedItems: addedItems, oldItems: oldItems, queue: queue, completion: completion)
    }
}
