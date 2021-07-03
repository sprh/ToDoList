//
//  FileCacheService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 01.07.2021.
//

import Foundation

class FileCacheService: FileCacheServiceProtocol {
    let queue = DispatchQueue(label: "com.ToDoList.FileCacheQueue")
    let fileCache = FileCache()
    func saveFile(fileName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            self?.fileCache.saveFile(to: fileName, completion: completion)
        }
    }
    func loadFile(fileName: String, completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        queue.async { [weak self] in
            self?.fileCache.loadFile(from: fileName, completion: completion)
        }
    }
}
