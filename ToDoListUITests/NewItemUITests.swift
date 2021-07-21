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
    }
    enum NewItem {
        static let textView = "text_view"
        static let saveButton = "save_button"
    }
}


class NewItemUITests: XCTestCase {
    let app = XCUIApplication()
    
    func testAvailableSeveButtonIfWeTryToCreateNewItemAndChangeText() {
        app.activate()
        app.buttons[AccessibilityIdentifiers.ItemsList.addButton].tap()
        let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
        let textView = app.textViews[AccessibilityIdentifiers.NewItem.textView]
        textView.tap()
        textView.typeText("The save button should now be enabled")
        XCTAssertTrue(saveButton.isEnabled)
        app.terminate()
    }
    
    func testSaveButtonShouldBecameUnenabledAfterTextWasDeleted() {
        app.activate()
        app.buttons[AccessibilityIdentifiers.ItemsList.addButton].tap()
        let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
        let textView = app.textViews[AccessibilityIdentifiers.NewItem.textView]
        let inputText = "Now the save button should not be enabled after deleting this"
        textView.tap()
        textView.typeText(inputText)
        textView.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: inputText.count))
        XCTAssertFalse(saveButton.isEnabled)
        app.terminate()
    }
}
