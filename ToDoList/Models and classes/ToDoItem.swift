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
    var deadline: Date?
    var deadlineSince1970: Double? {
        return deadline?.timeIntervalSince1970
    }
    /// - Parameters:
    ///     - id: An unique user id. Default value is UUID().uuidString
    ///     - text: The current do to item description.
    ///     - importance: A value that shows the importance of the task. Default value is unimportant.
    ///     - deadline: The task completeon date. An optional value of type Date.
    init(id: String? = UUID().uuidString, text: String, importance: Importance?, deadline: Date? = nil) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance ?? .unimportant
        self.deadline = deadline
    }
    /// - Parameters:
    ///     - id: An unique user id. Default value is UUID().uuidString
    ///     - text: The current do to item description.
    ///     - importance: A value that shows the importance of the task. Default value is unimportant.
    ///     - deadline: The task completeon date. An optional value of type Double.
    init(id: String? = UUID().uuidString, text: String, importance: Importance?, deadline: Double? = nil) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.importance = importance ?? .unimportant
        self.deadline = deadline == nil ? nil : Date(timeIntervalSince1970: deadline ?? 0)
    }
}

extension ToDoItem {

    /// This property creates json string with the object data.
    /// - Returns:
    ///         - The current object as a json string.
    var json: Any {
        let data = getAsDictionary()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return jsonData
        } catch {
            print(error.localizedDescription)
        }
        return (Any).self
    }
    /// To do item from a  json string parsing.
    ///
    /// - Parameters:
    ///         - json: A json string with data.
    /// - Returns:
    ///         - A to do item, loaded from json string.
    ///
    static func parce(json: Any) -> ToDoItem? {
        do {
            guard let json = json as? String else {
                print("Failed to load a to do item from json.")
                return nil
            }
            let jsonData = json.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            guard let data = try
                    JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject] else {
                print("Can't get the data from the json string.")
                return nil
            }
            let id = data.keys.contains("id") ? data["id"] as? String? : nil
            let text = data["text"] as? String
            let importanceString = data.keys.contains("importance") ? data["importance"] as? String: "unimportant"
            let importance = Importance(rawValue: importanceString ?? "unimportant")
            let deadline = data.keys.contains("deadline") ? data["deadline"] as? Double : nil
            return ToDoItem(id: id ?? nil, text: text!, importance: importance ?? nil, deadline: deadline ?? nil)
                            } catch {
                                print("Failed to load a to do item from json.")
                            }
        return nil
    }
    /// The function creates a dictionary from the object.
    fileprivate func getAsDictionary() -> [String: Any] {
        var data: [String: Any] = ["id": id, "text": text]
        if importance != .unimportant {
            data["importance"] = importance.rawValue
        }
        if deadline != nil {
            data["deadline"] = deadlineSince1970
        }
        return data
    }
}
