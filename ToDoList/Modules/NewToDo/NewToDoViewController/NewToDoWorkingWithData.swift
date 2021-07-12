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
        segmentedControl.selectedSegmentIndex =
            importanceAsArray.firstIndex(of: model.toDoItem.importance.rawValue) ?? 0
        if let deadline = model.toDoItem.deadline {
            deadlineSwitch.isOn = true
            deadlineSwitched()
            deadlinePicker.minimumDate = Date.init(timeIntervalSince1970: Double(deadline))
            deadlinePicker.date = Date.init(timeIntervalSince1970: Double(deadline))
            dateButton.setTitle(deadlinePicker.formattedDate(), for: .normal)
        }
        setupVisibility()
        textViewDidChange(textView)
        colorWasChanged()
        if let hexString = model.toDoItem.color {
            let color = UIColor.colorWithHexString(hexString: hexString)
            colorSlider.value = colorView.getValue(color: color)
            colorWasChanged()
        } else {
            resetColor()
        }
    }
    func getImportance() -> String {
        let index = segmentedControl.selectedSegmentIndex
        return importanceAsArray[index]
    }
}
