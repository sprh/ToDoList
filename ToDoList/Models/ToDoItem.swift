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
struct ToDoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Int?
    var done: Bool
    var color: String
    var createdAt: Int
    var updatedAt: Int
    var isDirty: Bool
    /// - Parameters:
    ///     - id: An unique user id. Default value is UUID().uuidString
    ///     - text: The current do to item description.
    ///     - importance: A value that shows the importance of the task. Default value is common..
    ///     - deadline: The task completeon date. An optional value of type Date.
    init(id: String? = UUID().uuidString,
         text: String,
         importance: Importance? = .basic,
         deadline: Int? = nil,
         color: String = "",
         done: Bool = false,
         updatedAt: Int,
         createdAt: Int = Int(Date().timeIntervalSince1970),
         isDirty: Bool = false) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance ?? .basic
        self.deadline = deadline
        self.color = color
        self.done = done
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isDirty = isDirty
    }
    init() {
        self.id = UUID().uuidString
        self.text = ""
        self.importance = .basic
        self.deadline = nil
        self.color = UIColor.hexStringFromColor(color: .text)
        self.done = false
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.updatedAt = Int(Date().timeIntervalSince1970)
        self.isDirty = false
    }
}

extension ToDoItem {

    /// This property creates json string with the object data.
    /// - Returns:
    ///         - The current object as a json string.
    var json: Any {
        var data: [String: Any] = ["id": id,
                                   "text": text,
                                   "color": color,
                                   "createdAt": createdAt,
                                   "updatedAt": updatedAt,
                                   "isDirty": isDirty,
                                   "done": done]
        if importance != .basic {
            data["importance"] = importance.rawValue
        }
        if deadline != nil {
            data["deadline"] = deadline
        }
        return data
    }
    /// To do item from a  json string parsing.
    ///
    /// - Parameters:
    ///         - json: A json string with data.
    /// - Returns:
    ///         - A to do item, loaded from json string.
    ///
    static func parse(json: Any) -> ToDoItem? {
        guard let data = json as? [String: Any] else { return nil }
        guard data.keys.contains("id"), data.keys.contains("text"),
              let id = data["id"] as? String, let text = data["text"] as? String else {
            return nil
        }
        let importanceString = data.keys.contains("importance") ? data["importance"] as? String: "basic"
        let importance = Importance(rawValue: importanceString ?? "common")
        let deadline = data.keys.contains("deadline") ? data["deadline"] as? Int : nil
        let color = data.keys.contains("color") ? data["color"] as? String : "#%06x"
        let done = data.keys.contains("done") ? data["done"] as? Bool : false
        let createdAt = data.keys.contains("createdAt") ? data["createdAt"] as? Int : -1
        let updatedAt = data.keys.contains("updatedAt") ? data["updatedAt"] as? Int : -1
        let isDirty = data.keys.contains("isDirty") ? data["isDirty"] as? Bool : false
        return ToDoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        color: color ?? "#%06x",
                        done: done ?? false,
                        updatedAt: updatedAt ?? -1,
                        createdAt: createdAt ?? -1,
                        isDirty: isDirty ?? false)
    }
}
