//
//  FileCache.swift
//  ToDoList
//
//  Created by Софья Тимохина on 09.06.2021.
//

import Foundation

final class FileCache {
    /// An array of to do items.
    private(set) var toDoItems: [ToDoItem] = []
    /// An array of tombstones.
    private(set) var tombstones: [Tombstone] = []
    /// Add an item to the array.
    ///  - Parameters:
    ///  - item: A new to do item.
    ///
    func add(item toDoItem: ToDoItem) {
        guard let index = toDoItems.firstIndex(where: {$0.id == toDoItem.id}) else {
            toDoItems.append(toDoItem)
            return
        }
        toDoItems[index] = toDoItem
        saveFile() { _ in
        }
    }
    func addTombstone(tombstone: Tombstone) {
        tombstones.append(tombstone)
    }
    func deleteTombstone(id: String) {
        guard let index = tombstones.firstIndex(where: {$0.id == id}) else { return }
        tombstones.remove(at: index)
    }
    /// Delete an element from the array by its id.
    /// - Parameters:
    /// - id: an identifire of the item.
    func delete(with id: String) {
        guard let index = toDoItems.firstIndex(where: {$0.id == id}) else { return }
        toDoItems.remove(at: index)
        saveFile() { _ in
        }
    }
    func get(with id: String) -> ToDoItem? {
        return toDoItems.first(where: {$0.id == id})
    }
    /// Save an array of objects to the file.
    /// - Parameters:
    /// - Path: a string contains the path to the file in which we save an array.
    func saveFile(to path: String = "todoitems.json",
                  completion: @escaping (Result<Void, Error>) -> Void) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else {
            completion(.failure(FileCacheError.fileNotFound))
            return
        }
        let jsonArray = toDoItems.map { $0.json }
        let url = documentDirectory.appendingPathComponent(path)
        do {
            let json = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try json.write(to: url, options: [])
        } catch {
            completion(.failure(FileCacheError.canNotWrite))
        }
        completion(.success(()))
    }
    /// Load an array of objects from the file.
    /// - Parameters:
    /// - Path: a string contains the path to the file from which we load an array.
    func loadFile(from path: String = "todoitems.json",
                  completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        // Check if a file with the path exists.
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else {
            completion(.failure(FileCacheError.fileNotFound))
            return
        }
        // Because we don't want to store repeatable elements.
        toDoItems.removeAll()
        let url = documentDirectory.appendingPathComponent(path)
        do {
            let json = try String(contentsOf: url, encoding: .utf8)
            let jsonData = json.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            guard let data = try
                    JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] else {
                print("Can't parse a json string")
                completion(.failure(FileCacheError.canNotRead))
                return
            }
            for item in data {
                guard let toDoItem = ToDoItem.parse(json: item) else {
                    continue
                }
                toDoItems.append(toDoItem)
            }
        } catch {
            completion(.failure(FileCacheError.canNotRead))
        }
        completion(.success(toDoItems))
    }
    func getDirties() -> [ToDoItem] {
        return toDoItems.filter({$0.isDirty})
    }
    func reloadItems(toDoItems: [ToDoItem], completion: @escaping () -> Void) {
        self.toDoItems = toDoItems
    }
}
