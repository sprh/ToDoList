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
    var deadline: Date?
    var done: Bool
    var deadlineSince1970: Double? {
        return deadline?.timeIntervalSince1970
    }
    var color: String
    /// - Parameters:
    ///     - id: An unique user id. Default value is UUID().uuidString
    ///     - text: The current do to item description.
    ///     - importance: A value that shows the importance of the task. Default value is common..
    ///     - deadline: The task completeon date. An optional value of type Date.
    init(id: String? = UUID().uuidString, text: String, importance: Importance? = .common,
         deadline: Date? = nil, color: String, done: Bool) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance ?? .common
        self.deadline = deadline
        self.color = color
        self.done = done
    }
    init() {
        self.id = UUID().uuidString
        self.text = ""
        self.importance = .common
        self.deadline = nil
        self.color = UIColor.hexStringFromColor(color: .text)
        self.done = false
    }
}

extension ToDoItem {

    /// This property creates json string with the object data.
    /// - Returns:
    ///         - The current object as a json string.
    var json: Any {
        var data: [String: Any] = ["id": id, "text": text, "color": color]
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
    static func parce(json: Any) -> ToDoItem? {
        guard let data = json as? [String: Any] else {
            return nil
        }
        let id = data.keys.contains("id") ? data["id"] as? String? : nil
        let text = data["text"] as? String
        let importanceString = data.keys.contains("importance") ? data["importance"] as? String: "common"
        let importance = Importance(rawValue: importanceString ?? "common")
        let deadline = data.keys.contains("deadline") ? data["deadline"] as? Double : nil
        let color = data.keys.contains("color") ? data["color"] as? String : "#%06x"
        let done = data.keys.contains("done") ? data["done"] as? Bool : false
        return ToDoItem(id: id ?? nil, text: text!, importance: importance,
                        deadline: Date.init(timeIntervalSince1970: deadline ?? 0), color: color ?? "#%06x", done: done ?? false)
    }
}
