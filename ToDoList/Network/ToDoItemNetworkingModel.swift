//
//  ToDoItemNetworkingModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 02.07.2021.
//

import Foundation

struct ToDoItemNetworkingModel: Codable {
    let id: String
    let text: String
    let importance: String
    let done: Bool
    let deadline: Int?
    let createdAt: Int
    let updatedAt: Int
    public init(toDoItem: ToDoItem) {
        id = toDoItem.id
        text = toDoItem.text
        importance = toDoItem.importance.rawValue
        done = toDoItem.done
        deadline = toDoItem.deadline
        createdAt = toDoItem.createdAt
        updatedAt = toDoItem.updatedAt
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        self.importance = try container.decode(String.self, forKey: .importance)
        self.done = try container.decode(Bool.self, forKey: .done)
        self.deadline = try container.decode(Int.self, forKey: .deadline)
        self.createdAt = try container.decode(Int.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Int.self, forKey: .updatedAt)
    }
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case done
        case deadline
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
