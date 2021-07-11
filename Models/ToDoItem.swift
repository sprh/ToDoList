//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Софья Тимохина on 08.06.2021.
//

import Foundation
import UIKit

/// An item of a to-do list structure.
///
public struct ToDoItem {
    public let id: String
    public let text: String
    public let importance: Importance
    public let deadline: Int?
    public var done: Bool
    public var color: String
    public var createdAt: Int
    public var updatedAt: Int?
    public var isDirty: Bool
    /// - Parameters:
    ///     - id: An unique user id. Default value is UUID().uuidString
    ///     - text: The current do to item description.
    ///     - importance: A value that shows the importance of the task. Default value is common..
    ///     - deadline: The task completeon date. An optional value of type Date.
    public init(id: String? = UUID().uuidString,
                text: String,
                importance: Importance? = .basic,
                deadline: Int? = nil,
                color: String = "",
                done: Bool = false,
                updatedAt: Int?,
                createdAt: Int = Int(Date().timeIntervalSince1970),
                isDirty: Bool = false) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance ?? .basic
        self.deadline = deadline
        self.color = color
        self.done = done
        self.createdAt = createdAt
        self.isDirty = isDirty
    }
    public init() {
        self.id = UUID().uuidString
        self.text = ""
        self.importance = .basic
        self.deadline = nil
        self.color = "#000000"
        self.done = false
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.updatedAt = Int(Date().timeIntervalSince1970)
        self.isDirty = false
    }
}

public extension ToDoItem {
    func markAsDirty() -> ToDoItem {
        return ToDoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        color: color,
                        done: done,
                        updatedAt: (Int)(Date().timeIntervalSince1970),
                        createdAt: createdAt,
                        isDirty: true)
    }
    public init(_ networkingModel: ToDoItemNetworkingModel) {
        id = networkingModel.id
        text = networkingModel.text
        importance = Importance.init(rawValue: networkingModel.importance) ?? .basic
        deadline = networkingModel.deadline
        color = "#000000"
        done = networkingModel.done
        createdAt = networkingModel.createdAt
        updatedAt = networkingModel.updatedAt
        isDirty = false
    }
}
