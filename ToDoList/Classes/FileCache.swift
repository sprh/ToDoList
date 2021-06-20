//
//  FileCache.swift
//  ToDoList
//
//  Created by Софья Тимохина on 09.06.2021.
//

import Foundation

class FileCache {
    /// An array of to do items.
    private(set) var toDoItems: [ToDoItem] = [ToDoItem(text: "Купить сыр", color: "", done: false),
                                 ToDoItem(text: "Купить сыр", color: "", done: true),
                                 ToDoItem(text: "Купить сыр", color: "", done: false),
                                 ToDoItem(text: "Купить сыр", color: "", done: true),
                                 ToDoItem(id: "", text: "Купить сыр", importance: .important,
                                          deadline: nil, color: "", done: false),
                                 ToDoItem(text: "Купить сыр", color: "", done: false),
                                 ToDoItem(text: "Купить сыр", color: "", done: true),
                                 ToDoItem(text: "Купить сыр", color: "", done: false),
                                 ToDoItem(text: "Купить сыр", color: "", done: true),
                                 ToDoItem(id: "", text: "Купить сыр", importance: .important,
                                                    deadline: nil, color: "", done: false),
                                 ToDoItem(text: "Купить сыр", color: "", done: false),
                                 ToDoItem(text: "Купить сыр", color: "", done: true),
                                 ToDoItem(text: "Купить сыр", color: "", done: false),
                                 ToDoItem(text: "Купить сыр", color: "", done: true),
                                 ToDoItem(id: "", text: "Купить сыр", importance: .important,
                                                    deadline: nil, color: "", done: false),
                                 ToDoItem(id: "", text: "Купить что-то, где-то, зачем-то, но зачем?", importance: .important, deadline: nil, color: "", done: true),
                                 ToDoItem(id: "", text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать, что необходимо купить сыр", importance:
                                            .important, deadline: nil, color: "", done: true),
                                 ToDoItem(text: "Купить сыр", color: "", done: false)]
    /// Add an item to the array.
    ///  - Parameters:
    ///  - item: A new to do item.
    ///
    func add(item toDoItem: ToDoItem) {
        toDoItems.append(toDoItem)
    }
    /// Delete an element from the array by its id.
    /// - Parameters:
    /// - id: an identifire of the item.
    func delete(with id: String) {
        guard let index = toDoItems.firstIndex(where: {$0.id == id}) else {
            return
        }
        toDoItems.remove(at: index)
    }
    func get(with id: String) -> ToDoItem? {
        return toDoItems.first(where: {$0.id == id})
    }
    /// Save an array of objects to the file.
    /// - Parameters:
    /// - Path: a string contains the path to the file in which we save an array.
    func saveFile(to path: String = "todoitems.json") {
        var jsonArray: [Any] = []
        toDoItems.forEach { jsonArray.append($0.json) }
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first else {
            return
        }
        let url = documentDirectory.appendingPathComponent(path)
        print(url)
        do {
            let json = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try json.write(to: url, options: [])
        } catch {
            print("Can't write the data to the json file!")
        }
    }
    /// Load an array of objects from the file.
    /// - Parameters:
    /// - Path: a string contains the path to the file from which we load an array.
    func loadFile(from path: String = "todoitems.json") {
        // Check if a file with the path exists.
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first else {
            return
        }
        let url = documentDirectory.appendingPathComponent(path)
        do {
            let json = try String(contentsOf: url, encoding: .utf8)
            let jsonData = json.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            guard let data = try
                    JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] else {
                print("Can't parse a json string")
                return
            }
            for item in data {
                guard let toDoItem = ToDoItem.parce(json: item) else {
                    continue
                }
                toDoItems.append(toDoItem)
            }
        } catch {
            print("Can't read the file.")
        }
    }
}
