//
//  NewToDoWorkingWithData.swift
//  ToDoList
//
//  Created by Софья Тимохина on 26.06.2021.
//

import UIKit

extension NewToDoViewController {
    func loadData() {
        textView.text = model.toDoItem.text
        if let deadline = model.toDoItem.deadline {
            deadlineSwitch.isOn = true
            deadlineSwitched()
            deadlinePicker.minimumDate = min(Date(), deadline)
            deadlinePicker.date = deadline
        }
        segmentedControl.selectedSegmentIndex =
            importanceAsArray.firstIndex(of: model.toDoItem.importance.rawValue) ?? 0
        let color = UIColor.colorWithHexString(hexString: model.toDoItem.color)
        textView.textColor = color
        colorSlider.thumbTintColor = color
        setupVisability()
        textViewDidChange(textView)
    }
    func getImportance() -> String {
        let index = segmentedControl.selectedSegmentIndex
        return importanceAsArray[index]
    }
}
