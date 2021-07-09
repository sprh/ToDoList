//
//  FileCache.swift
//  ToDoList
//
//  Created by Софья Тимохина on 09.06.2021.
//

import Foundation
import Models
import SQLite

final class FileCache {
    /// An array of to do items.
    private(set) var toDoItems: [ToDoItem] = []
    /// An array of tombstones.
    private(set) var tombstones: [Tombstone] = []
    let id = Expression<String>("id")
    let text = Expression<String>("text")
    let importance = Expression<String>("importance")
    let deadline = Expression<Int?>("deadline")
    let done = Expression<Bool>("done")
    let color = Expression<String>("color")
    let createdAt = Expression<Int>("createdAt")
    let updatedAt = Expression<Int?>("updatedAt")
    let isDirty = Expression<Bool>("isDirty")
    var dbUrl: URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else {
                return nil
            }
        let path = documentDirectory.appendingPathComponent("ToDoList.sqlite3")
        return path
    }
//    let tombstoneId = Expression<String>("id")
    let deletedAt = Expression<String>("deletedAt")
    public init() {
        do {
            try createTables()
        } catch let error {
            print(":( \(error)")
        }
    }
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
    }
    func get(with id: String) -> ToDoItem? {
        return toDoItems.first(where: {$0.id == id})
    }
    /// Save an array of objects to the file.
    /// - Parameters:
    /// - Path: a string contains the path to the file in which we save an array.
    func saveFile(_ items: [ToDoItem], to path: String,
                  completion: @escaping (Result) -> Void) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else {
            return
        }
        let jsonArray = toDoItems.map { $0.json }
        let url = documentDirectory.appendingPathComponent(path)
        do {
            let json = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try json.write(to: url, options: [])
        } catch {
            return
        }
    }
    /// Load an array of objects from the file.
    /// - Parameters:
    /// - Path: a string contains the path to the file from which we load an array.
    func loadFile(from path: String,
                  completion: @escaping (Result) -> Void) {
        // Check if a file with the path exists.
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else {
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
                return
            }
            for item in data {
                guard let toDoItem = ToDoItem.parse(json: item) else {
                    continue
                }
                toDoItems.append(toDoItem)
            }
        } catch {
        }
    }
    func reloadItems(toDoItems: [ToDoItem]) {
        self.toDoItems = toDoItems
    }
    func clearTombstones() {
        tombstones.removeAll()
    }
    func createTables() throws {
        guard let dbUrl = dbUrl else { return }
        FileManager.createFileIfNotExists(with: dbUrl)
        print(FileManager.default.fileExists(atPath: dbUrl.path))
        let connection = try Connection(dbUrl.path)
        let toDoItems = Table("ToDoItems")
        let tombstones = Table("Tombstones")
        try connection.run(toDoItems.create(ifNotExists: true) { table in
            table.column(id, primaryKey: true)
            table.column(text)
            table.column(importance)
            table.column(deadline)
            table.column(done)
            table.column(color)
            table.column(createdAt)
            table.column(updatedAt)
            table.column(isDirty)
        })
        try connection.run(tombstones.create(ifNotExists: true) { table in
            table.column(id, primaryKey: true)
            table.column(deletedAt)
        })
    }
}
