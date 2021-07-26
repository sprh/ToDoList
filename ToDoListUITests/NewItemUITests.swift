//
//  NewItemUITests.swift
//  ToDoListUITests
//
//  Created by Софья Тимохина on 21.07.2021.
//

import XCTest
@testable import ToDoList

enum AccessibilityIdentifiers {
    enum ItemsList {
        static let addButton = "add_button"
        static let tableView = "table_view"
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
}

class NewItemUITests: XCTestCase {
    func testSaveButtonIsEnabledAfterTextWasChanged_WithNewItem() {
        let app = XCUIApplication()
        app.launchArguments.append("testing")
        app.launch()
        app.buttons[AccessibilityIdentifiers.ItemsList.addButton].tap()
        let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
        let textView = app.textViews[AccessibilityIdentifiers.NewItem.textView]
        textView.tap()
        textView.typeText("The save button should now be enabled")
        XCTAssertTrue(saveButton.isEnabled)
    }
    
    func testSaveButtonIsNotEnabledAfterTextWasDeleted_WithNewItem() {
        let app = XCUIApplication()
        app.launchArguments.append("testing")
        app.launch()
        app.buttons[AccessibilityIdentifiers.ItemsList.addButton].tap()
        let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
        let textView = app.textViews[AccessibilityIdentifiers.NewItem.textView]
        let inputText = "Now the save button should not be enabled after deleting this"
        textView.tap()
        textView.typeText(inputText)
        textView.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: inputText.count))
        XCTAssertFalse(saveButton.isEnabled)
    }
    
    func testSaveButtonIsNotEnabledAfterOpeningItem_WithOldItem() {
        let app = XCUIApplication()
        app.launchArguments.append("testing")
        app.launch()
        let tableView = app.tables[AccessibilityIdentifiers.ItemsList.tableView]
        if tableView.cells.element(boundBy: 0).exists {
            tableView.cells.element(boundBy: 0).tap()
            let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
            XCTAssertFalse(saveButton.isEnabled)
        }
    }
    
    func testSaveButtonIsEnabledAfterItemTextWasChanged_WithOldItem() {
        let app = XCUIApplication()
        app.launchArguments.append("testing")
        app.launch()
        let tableView = app.tables[AccessibilityIdentifiers.ItemsList.tableView]
        if tableView.cells.element(boundBy: 0).exists {
            tableView.cells.element(boundBy: 0).tap()
            let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
            let textView = app.textViews[AccessibilityIdentifiers.NewItem.textView]
            textView.tap()
            textView.typeText(" and now we see that save button is enabled")
            XCTAssertTrue(saveButton.isEnabled)
        }
    }
    
    func testButtonIsEnabledAfterImportanceWasChanged_WithOldItem() {
        let app = XCUIApplication()
        app.launchArguments.append("testing")
        app.launch()
        let tableView = app.tables[AccessibilityIdentifiers.ItemsList.tableView]
        if tableView.cells.element(boundBy: 0).exists {
            tableView.cells.element(boundBy: 0).tap()
            let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
            let importanceSegmentedControl = app.segmentedControls[AccessibilityIdentifiers.NewItem.segmentedControl]
            
        }
    }
}
