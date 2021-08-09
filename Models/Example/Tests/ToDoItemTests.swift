//
//  ToDoItemTests.swift
//  Models_Tests
//
//  Created by Софья Тимохина on 26.07.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import Models

class ToDoItemTests: XCTestCase {
    func testChangeDoneWorks() {
        let text = "text"
        let notDoneItem = ToDoItem(text: text, done: false)
        let doneItem = notDoneItem.changeDone()
        XCTAssertTrue(doneItem.done && doneItem.text == text)
    }
    
    func testMarkAsDirtyWorks() {
        let text = "text"
        let notDirtyItem = ToDoItem(text: text, done: false)
        let dirtyItemItem = notDirtyItem.markAsDirty()
        XCTAssertTrue(dirtyItemItem.isDirty && dirtyItemItem.text == text)
    }
}
