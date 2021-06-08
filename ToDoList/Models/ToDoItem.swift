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
    var deadline: Optional<Date>
    var Deadline: Optional<Double> {
        get {
            return deadline?.timeIntervalSince1970
        }
        set(date) {
            deadline = Date(timeIntervalSince1970: date ?? 0)
        }
        
    }
    
    /// - Parameters:
    ///     - id: An unique user id. Default value is UUID().uuidString
    ///     - text: The current do to item description.
    ///     - importance: A value that shows the importance of the task. Default value is unimportant.
    ///     - deadline: The task completeon date. An optional value.
    init(id: String = UUID().uuidString, text: String, importance: Importance = .unimportant, deadline: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
    }
}

extension ToDoItem {

//    static func parce(json: Any) -> ToDoItem? {
//        do {
//            let jsonData = (json as! String).data(using: String.Encoding.utf8, allowLossyConversion: false)!
//            let data = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: AnyObject]
//            let id = data["id"] as? String
//            let text = data["text"] as? String
//            let importance = data["importance"] as? Importance
//        }catch {
//            print("Error")
//        }
//    }
    
    
}
