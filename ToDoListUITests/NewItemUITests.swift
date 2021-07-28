//
//  NewItemUITests.swift
//  ToDoListUITests
//
//  Created by Софья Тимохина on 21.07.2021.
//

import XCTest
@testable import ToDoList

class NewItemUITests: XCTestCase {
    let app = XCUIApplication()
    func selectFirstCellIfExists() -> Bool {
        let tableView = app.tables[AccessibilityIdentifiers.ItemsList.tableView]
        if tableView.cells.element(boundBy: 0).exists {
            tableView.cells.element(boundBy: 0).tap()
            return true
        }
        return false
    }
    
    func launch() {
        app.launchArguments.append("testing")
        app.launch()
    }
    
    func testSaveButtonIsEnabledAfterTextWasChanged_WithNewItem() {
        launch()
        app.buttons[AccessibilityIdentifiers.ItemsList.addButton].tap()
        let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
        let textView = app.textViews[AccessibilityIdentifiers.NewItem.textView]
        textView.tap()
        textView.typeText("The save button should now be enabled")
        XCTAssertTrue(saveButton.isEnabled)
    }
    
    func testSaveButtonIsNotEnabledAfterTextWasDeleted_WithNewItem() {
        launch()
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
        launch()
        if selectFirstCellIfExists() {
            let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
            XCTAssertFalse(saveButton.isEnabled)
        }
    }
    
    func testSaveButtonIsEnabledAfterItemTextWasChanged_WithOldItem() {
        launch()
        if selectFirstCellIfExists() {
            let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
            let textView = app.textViews[AccessibilityIdentifiers.NewItem.textView]
            textView.tap()
            textView.typeText(" and now we see that save button is enabled")
            XCTAssertTrue(saveButton.isEnabled)
        }
    }
    
    func testButtonIsEnabledAfterImportanceWasChanged_WithOldItem() {
        launch()
        if selectFirstCellIfExists() {
            let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
            let importanceSegmentedControl = app.segmentedControls[AccessibilityIdentifiers.NewItem.segmentedControl]
            if importanceSegmentedControl.buttons.element(boundBy: 2).isSelected {
                importanceSegmentedControl.swipeLeft()
            } else {
                importanceSegmentedControl.swipeRight()
            }
            XCTAssertTrue(saveButton.isEnabled)
        }
    }
    
    func testButtonIsEnabledAfterDeadlineWasChanged_WithOldItem() {
        launch()
        if selectFirstCellIfExists() {
            let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
            let deadlineSwitch = app.switches[AccessibilityIdentifiers.NewItem.deadlineSwitch]
            let value = deadlineSwitch.value as? String
            if value == "0" {
                deadlineSwitch.swipeRight()
            } else {
                deadlineSwitch.swipeLeft()
            }
            XCTAssertTrue(saveButton.isEnabled)
        }
    }
    
    func addItem(with text: String) {
        let textView = app.textViews[AccessibilityIdentifiers.NewItem.textView]
        let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
        app.buttons[AccessibilityIdentifiers.ItemsList.addButton].tap()
        textView.tap()
        textView.typeText(text)
        saveButton.tap()

    }
    
    func updateItem(with text: String, oldText: String, cell: XCUIElement) {
        cell.tap()
        let textView = app.textViews[AccessibilityIdentifiers.NewItem.textView]
        let saveButton = app.buttons[AccessibilityIdentifiers.NewItem.saveButton]
        let lowerRightCorner = textView.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.9))
        
        lowerRightCorner.tap()
        textView.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: oldText.count))
        textView.typeText(text)
        saveButton.tap()
    }
    
    func testItemsTextChanges() {
        launch()
        let tableView = app.tables[AccessibilityIdentifiers.ItemsList.tableView]
        let text = "New item"
        let updatedText = "Updated item"
        var cellsCount = tableView.cells.count
        addItem(with: text)
        assert(cellsCount + 1 == tableView.cells.count)
        cellsCount += 1
        
        let addedCell = tableView.cells.element(boundBy: tableView.cells.count - 2)
        updateItem(with: updatedText, oldText: text, cell: addedCell)
        assert(cellsCount == tableView.cells.count)
        let cellText = addedCell.staticTexts[AccessibilityIdentifiers.ToDoCell.labelText].label as String
        XCTAssertTrue(cellText == updatedText)
    }
}
