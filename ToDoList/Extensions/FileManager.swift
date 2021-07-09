//
//  FileManager.swift
//  ToDoList
//
//  Created by Софья Тимохина on 09.07.2021.
//

import Foundation

extension FileManager {
    static public func createFileIfNotExists(with path: URL) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path.path) {
            fileManager.createFile(atPath: path.path, contents: nil, attributes: nil)
        }
    }
}
