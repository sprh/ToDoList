//
//  Tombstone.swift
//  ToDoList
//
//  Created by Софья Тимохина on 02.07.2021.
//

import Foundation

public struct Tombstone {
    public let id: String
    public let deletedAt: Int
    public init(id: String) {
        self.id = id
        deletedAt = Int(Date().timeIntervalSince1970)
    }
    public init(id: String, deletedAt: Int) {
        self.id = id
        self.deletedAt = deletedAt
    }
}
