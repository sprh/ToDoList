//
//  FileCacheService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 01.07.2021.
//

import Foundation
import Models

class FileCacheService: FileCacheServiceProtocol {
    let queue = DispatchQueue(label: "com.ToDoList.FileCacheQueue")
    let fileCache = FileCache()
    public init() {
    }
    func saveFile(items: [ToDoItem], fileName: String = "todoitems.json",
                  completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            self?.fileCache.saveFile(items, to: fileName, completion: completion)
        }
    }
    func loadFile(fileName: String = "todoitems.json",
                  completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        queue.async { [weak self] in
            self?.fileCache.loadFile(from: fileName, completion: completion)
        }
    }
    func addTombstone(tombstone: Tombstone) {
        fileCache.addTombstone(tombstone: tombstone)
    }
    func clearTombstones() {
        fileCache.clearTombstones()
    }
    var dirties: [ToDoItem] {
        return fileCache.toDoItems.filter({$0.isDirty})
    }
    var tombstones: [Tombstone] {
        return fileCache.tombstones
    }
    func reloadItems(items: [ToDoItem]) {
        fileCache.reloadItems(toDoItems: items)
    }
}
