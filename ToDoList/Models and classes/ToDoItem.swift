//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Софья Тимохина on 08.06.2021.
//

import Foundation

/// An item of a to-do list structure.
///
struct ToDoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    var deadlineSince1970: Double? {
        return deadline?.timeIntervalSince1970
    }
    /// - Parameters:
    ///     - id: An unique user id. Default value is UUID().uuidString
    ///     - text: The current do to item description.
    ///     - importance: A value that shows the importance of the task. Default value is common..
    ///     - deadline: The task completeon date. An optional value of type Date.
    init(id: String? = UUID().uuidString, text: String, importance: Importance? = .common, deadline: Date?) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance ?? .common
        self.deadline = deadline
    }
    /// - Parameters:
    ///     - id: An unique user id. Default value is UUID().uuidString
    ///     - text: The current do to item description.
    ///     - importance: A value that shows the importance of the task. Default value is common.
    ///     - deadline: The task completeon date. An optional value of type Double.
    init(id: String? = UUID().uuidString, text: String, importance: Importance? = .common, deadline: Double? = nil) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance ?? .common
        self.deadline = deadline == nil ? nil : Date(timeIntervalSince1970: deadline ?? 0)
    }
}

extension ToDoItem {

    /// This property creates json string with the object data.
    /// - Returns:
    ///         - The current object as a json string.
    var json: Any {
        var data: [String: Any] = ["id": id, "text": text]
        if importance != .common {
            data["importance"] = importance.rawValue
        }
        if deadline != nil {
            data["deadline"] = deadlineSince1970
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
        guard data.keys.contains("id"), let id = data["id"] as? String else {
            return nil
        }
        let text = data["text"] as? String
        let importanceString = data.keys.contains("importance") ? data["importance"] as? String: "common"
        let importance = Importance(rawValue: importanceString ?? "common")
        let deadline = data.keys.contains("deadline") ? data["deadline"] as? Double : nil
        return ToDoItem(id: id, text: text!, importance: importance, deadline: deadline ?? nil)
    }
}
