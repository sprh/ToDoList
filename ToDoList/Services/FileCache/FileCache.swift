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
    let deletedAt = Expression<Int>("deletedAt")
    let toDoItemsTable = Table("ToDoItems")
    let tombstonesTable = Table("Tombstones")
    var dbUrl: URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else {
            return nil
        }
        let path = documentDirectory.appendingPathComponent("ToDoList.sqlite3")
        return path
    }
    public init() {
        do {
            try createTables()
        } catch let error {
            print(":( \(error)")
        }
    }
    func saveFile(items: [ToDoItem], completion: ([ToDoItem]) -> Void) throws {
        guard let dbUrl = dbUrl else { return }
        var dbItems: [ToDoItem] = []
        try getToDoItems { items in
            dbItems = items
        }
        let connection = try Connection(dbUrl.path)
        let itemsIds = items.map({$0.id})
        let dbItemsIds = dbItems.map({$0.id})
        let itemsToDelete = toDoItemsTable.filter(!itemsIds.contains(id))
        let itemsToAdd = items.filter({!dbItemsIds.contains($0.id)})
        try connection.run(itemsToDelete.delete())
        for item in itemsToAdd {
            try create(item)
        }
        completion(items)
    }
    func loadFile() throws {
        try getToDoItems { [weak self] items in
            self?.toDoItems = items
        }
        try getTombstones { [weak self] items in
            self?.tombstones = items
        }
    }
    func reloadItems(toDoItems: [ToDoItem]) {
        self.toDoItems = toDoItems
    }
    func clearTombstones() throws {
        guard let dbUrl = dbUrl else { return }
        let connection = try Connection(dbUrl.path)
        try connection.run(tombstonesTable.delete())
        tombstones.removeAll()
    }
    func createTables() throws {
        guard let dbUrl = dbUrl else { return }
        FileManager.createFileIfNotExists(with: dbUrl)
        let connection = try Connection(dbUrl.path)
        try connection.run(toDoItemsTable.create(ifNotExists: true) { table in
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
        try connection.run(tombstonesTable.create(ifNotExists: true) { table in
            table.column(id, primaryKey: true)
            table.column(deletedAt)
        })
    }
    func getToDoItems(completion: ([ToDoItem]) -> Void) throws {
        guard let dbUrl = dbUrl else { return }
        toDoItems.removeAll()
        let connection = try Connection(dbUrl.path)
        var items: [ToDoItem] = []
        for item in try connection.prepare(toDoItemsTable) {
            let toDoItem = ToDoItem(id: item[id],
                                    text: item[text],
                                    importance: Importance(rawValue: item[importance]),
                                    deadline: item[deadline],
                                    color: item[color],
                                    done: item[done],
                                    updatedAt: item[updatedAt],
                                    createdAt: item[createdAt],
                                    isDirty: item[isDirty])
            items.append(toDoItem)
        }
        completion(items)
    }
    func getTombstones(completion: ([Tombstone]) -> Void) throws {
        guard let dbUrl = dbUrl else { return }
        let connection = try Connection(dbUrl.path)
        var tombstones: [Tombstone] = []
        for item in try connection.prepare(tombstonesTable) {
            let tombstone = Tombstone(id: item[id],
                                     deletedAt: item[deletedAt])
            tombstones.append(tombstone)
        }
        completion(tombstones)
    }
    func create(_ item: ToDoItem) throws {
        guard let dbUrl = dbUrl else { return }
        let connection = try Connection(dbUrl.path)
        try connection.run(toDoItemsTable.insert(id <- item.id,
                                                 text <- item.text,
                                                 importance <- item.importance.rawValue,
                                                 deadline <- item.deadline,
                                                 done <- item.done,
                                                 color <- item.color,
                                                 createdAt <- item.createdAt,
                                                 updatedAt <- item.updatedAt,
                                                 isDirty <- item.isDirty))
    }
    func create(_ item: Tombstone) throws {
        guard let dbUrl = dbUrl else { return }
        let connection = try Connection(dbUrl.path)
        try connection.run(tombstonesTable.insert(id <- item.id,
                                                  deletedAt <- item.deletedAt))
    }
    func update(_ item: ToDoItem) throws {
        guard let dbUrl = dbUrl else { return }
        let connection = try Connection(dbUrl.path)
        let toDoItem = toDoItemsTable.filter(id == item.id)
        try connection.run(toDoItem.update(text <- item.text,
                                           importance <- item.importance.rawValue,
                                           deadline <- item.deadline,
                                           done <- item.done,
                                           color <- item.color,
                                           updatedAt <- item.updatedAt,
                                           isDirty <- item.isDirty))
    }
    func deleteToDoItem(_ id: String) throws {
        guard let dbUrl = dbUrl else { return }
        let connection = try Connection(dbUrl.path)
        let toDoItem = toDoItemsTable.filter(self.id == id)
        try connection.run(toDoItem.delete())
    }
    func deleteTombstone(_ id: String) throws {
        guard let dbUrl = dbUrl else { return }
        let connection = try Connection(dbUrl.path)
        let tombstone = tombstonesTable.filter(self.id == id)
        try connection.run(tombstone.delete())
    }
}
