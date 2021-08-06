//
//  AccessibilityIdentifiers.swift
//  ToDoList
//
//  Created by Софья Тимохина on 21.07.2021.
//

import Foundation

enum AccessibilityIdentifiers {
    enum ItemsList {
        static let addButton = "add_button"
        static let tableView = "table_view"
        static let showButton = "show_button"
    }
    enum NewItem {
        static let textView = "text_view"
        static let saveButton = "save_button"
        static let deadlineSwitch = "deadline_switch"
        static let segmentedControl = "segmented_control"
        static let deleteButton = "delete_button"
        static let deadlinePicker = "deadline_picker"
        static let dateButton = "date_button"
    }
    enum ToDoCell {
        static let labelText = "label_text"
        static let doneButton = "done_button"
    }
}
