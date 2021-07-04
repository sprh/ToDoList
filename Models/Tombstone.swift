//
//  Tombstone.swift
//  ToDoList
//
//  Created by Софья Тимохина on 02.07.2021.
//

import Foundation

struct Tombstone {
    let id: String
    let deletedAt: Int
    public init(id: String) {
        self.id = id
        deletedAt = Int(Date().timeIntervalSince1970)
    }
}
