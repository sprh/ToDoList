//
//  ToDoItemNetworkingModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 02.07.2021.
//

import Foundation

public struct ToDoItemNetworkingModel: Codable {
    public let id: String
    public let text: String
    public let importance: String
    public let done: Bool
    public let deadline: Int?
    public let createdAt: Int
    public let updatedAt: Int?
    public init(_ toDoItem: ToDoItem) {
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
        self.deadline = try container.decode(Int?.self, forKey: .deadline)
        self.createdAt = try container.decode(Int.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Int?.self, forKey: .updatedAt)
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(importance, forKey: .importance)
        try container.encode(done, forKey: .done)
        try container.encode(deadline, forKey: .deadline)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
    
    public var json: [String: Any?] {
        return ["id": id,
                "text": text,
                "importance": importance,
                "done": done,
                "deadline": deadline,
                "created_at": createdAt,
                "updated_at": updatedAt]
    }
}
