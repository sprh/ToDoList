//
//  FileCache.swift
//  ToDoList
//
//  Created by Софья Тимохина on 09.06.2021.
//

import Foundation

final class FileCache {
    /// An array of to do items.
    private(set) var toDoItems: [ToDoItem] =
            [ToDoItem(id: "1", text: "Купить сыр", deadline: Date(), color: "", done: false),
             ToDoItem(id: "2", text: "Купить сыр", deadline: Date(), color: "", done: true),
             ToDoItem(id: "3", text: "Купить сыр", color: "", done: false),
      ToDoItem(id: "4", text: "Купить сыр", deadline: Date(), color: "", done: true),
      ToDoItem(id: "5", text: "Купить сыр", importance: .important,
           deadline: nil, color: "", done: false),
      ToDoItem(id: "6", text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать, что необходимо купить сыр", importance:
              .important, deadline: nil, color: "", done: true),
      ToDoItem(id: "7", text: "Купить сыр", color: "", done: false),
      ToDoItem(id: "1", text: "Купить сыр", deadline: Date(), color: "", done: false),
       ToDoItem(id: "2", text: "Купить сыр", deadline: Date(), color: "", done: true),
       ToDoItem(id: "3", text: "Купить сыр", color: "", done: false),
       ToDoItem(id: "1", text: "Купить сыр", deadline: Date(), color: "", done: false),
        ToDoItem(id: "2", text: "Купить сыр", deadline: Date(), color: "", done: true),
        ToDoItem(id: "3", text: "Купить сыр", color: "", done: false),
        ToDoItem(id: "1", text: "Купить сыр", deadline: Date(), color: "", done: false),
         ToDoItem(id: "2", text: "Купить сыр", deadline: Date(), color: "", done: true),
         ToDoItem(id: "3", text: "Купить сыр", color: "", done: false)]
    /// Add an item to the array.
    ///  - Parameters:
    ///  - item: A new to do item.
    ///
    func add(item toDoItem: ToDoItem) {
        let queue = DispatchQueue.global(qos: .background)
        let workItem = DispatchWorkItem { [weak self] in
            guard let index = self?.toDoItems.firstIndex(where: {$0.id == toDoItem.id}) else {
                self?.toDoItems.append(toDoItem)
                return
            }
            self?.toDoItems[index] = toDoItem
        }
        queue.async(execute: workItem)
    }
    /// Delete an element from the array by its id.
    /// - Parameters:
    /// - id: an identifire of the item.
    func delete(with id: String) {
        let queue = DispatchQueue.global(qos: .background)
        let workItem = DispatchWorkItem { [weak self] in
            guard let index = self?.toDoItems.firstIndex(where: {$0.id == id}) else { return }
            self?.toDoItems.remove(at: index)
        }
        queue.async(execute: workItem)
    }
    func get(with id: String) -> ToDoItem? {
        var toDoItem: ToDoItem?
        let queue = DispatchQueue.global(qos: .background)
        let workItem = DispatchWorkItem { [weak self] in
            toDoItem = self?.toDoItems.first(where: {$0.id == id})
        }
        queue.async(execute: workItem)
        return toDoItem
    }
    /// Save an array of objects to the file.
    /// - Parameters:
    /// - Path: a string contains the path to the file in which we save an array.
    func saveFile(to path: String = "todoitems.json", closure: @escaping (FileCacheError) -> Void) {
        let queue = DispatchQueue.global(qos: .background)
        let workItem = DispatchWorkItem { [weak self] in
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first else {
                closure(FileCacheError.fileNotFound)
                return
            }
            let jsonArray = self?.toDoItems.map { $0.json }
            let url = documentDirectory.appendingPathComponent(path)
            do {
                let json = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
                try json.write(to: url, options: [])
            } catch {
                closure(FileCacheError.canNotWrite)
            }
        }
        queue.async(execute: workItem)
    }
    /// Load an array of objects from the file.
    /// - Parameters:
    /// - Path: a string contains the path to the file from which we load an array.
    func loadFile(from path: String = "todoitems.json", closure: @escaping (FileCacheError) -> Void) {
        let queue = DispatchQueue.global(qos: .background)
        let workItem = DispatchWorkItem { [weak self] in
            // Check if a file with the path exists.
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                   in: .userDomainMask).first else {
                closure(FileCacheError.fileNotFound)
                return
            }
            // Because we don't want to store repeatable elements.
            self?.toDoItems.removeAll()
            let url = documentDirectory.appendingPathComponent(path)
            do {
                let json = try String(contentsOf: url, encoding: .utf8)
                let jsonData = json.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                guard let data = try
                        JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] else {
                    print("Can't parse a json string")
                    closure(FileCacheError.canNotRead)
                    return
                }
                for item in data {
                    guard let toDoItem = ToDoItem.parse(json: item) else {
                        continue
                    }
                    self?.toDoItems.append(toDoItem)
                }
            } catch {
                closure(FileCacheError.canNotRead)
            }
        }
        queue.async(execute: workItem)
    }
}
