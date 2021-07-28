//
//  ItemsListTests.swift
//  ToDoListTests
//
//  Created by Софья Тимохина on 21.07.2021.
//

import XCTest
@testable import ToDoList
@testable import Models

class ItemsListTests: XCTestCase {
    func prepareModel() -> ItemsListModel {
        let service = FakeToDoService(fileCacheService: FakeFileCacheService(), networkingService: FakeNetworkingService())
        let model = ItemsListModel(toDoService: service)
        model.allItems = service.toDoItems
        return model
    }
    
    func testDoneItemsHiddenIfDoneElementsHidden() {
        let model = prepareModel()
        model.doneShown = false
        XCTAssertFalse(model.items.contains(where: {$0.done}))
        XCTAssertTrue(model.allItems.count - model.doneItemsCount == model.items.count)
    }
    
    func testAllItemsShownIfDoneItemsShown() {
        let model = prepareModel()
        model.doneShown = true
        XCTAssertTrue(model.items == model.allItems)
    }
    
    func testIfAddedItemChangesDoneAndDoneItemsAreNotShownItIsNotShown() {
        let model = prepareModel()
        model.doneShown = false
        var toDoItem = ToDoItem(id: "test", text: "test") // Default: isDone = false
        model.addItem(toDoItem) { }
        XCTAssertTrue(model.items.contains(where: {$0.id == "test"}))
        toDoItem = toDoItem.changeDone() // isDone = true
        model.updateItem(toDoItem) {}
        XCTAssertFalse(model.items.contains(where: {$0.id == "test"}))
    }
}
