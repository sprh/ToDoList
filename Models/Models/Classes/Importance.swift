//
//  Importance.swift
//  ToDoList
//
//  Created by Софья Тимохина on 08.06.2021.
//

import Foundation

/// A value that shows how important is the task.
/// - Cases: unimportant, common important.
public enum Importance: String {
    case low
    case basic
    case important
}
