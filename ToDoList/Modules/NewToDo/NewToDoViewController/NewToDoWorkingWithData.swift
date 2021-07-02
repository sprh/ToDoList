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
        guard let deadline = model.toDoItem.deadline else { return }
        deadlineSwitch.isOn = true
        deadlineSwitched()
        deadlinePicker.minimumDate = Date.init(timeIntervalSince1970: Double(deadline))
        deadlinePicker.date = Date.init(timeIntervalSince1970: Double(deadline))
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
