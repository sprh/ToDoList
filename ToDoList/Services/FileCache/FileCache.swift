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
    /// Save an array of objects to the file.
    /// - Parameters:
    /// - Path: a string contains the path to the file in which we save an array.
    func saveFile() {
        // TODO: Save file
    }
    /// Load an array of objects from the file.
    /// - Parameters:
    /// - Path: a string contains the path to the file from which we load an array.
    func loadFile() throws {
        try getToDoItems()
        try getTombstones()
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
    func getToDoItems() throws {
        guard let dbUrl = dbUrl else { return }
        let connection = try Connection(dbUrl.path)
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
            toDoItems.append(toDoItem)
        }
    }
    func getTombstones() throws {
        guard let dbUrl = dbUrl else { return }
        let connection = try Connection(dbUrl.path)
        for item in try connection.prepare(tombstonesTable) {
            let tombstone = Tombstone(id: item[id],
                                     deletedAt: item[deletedAt])
            tombstones.append(tombstone)
        }
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
