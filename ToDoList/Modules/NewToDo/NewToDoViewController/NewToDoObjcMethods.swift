//
//  NewToDoObjcMethods.swift
//  ToDoList
//
//  Created by Софья Тимохина on 26.06.2021.
//

import UIKit

extension NewToDoViewController {
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @objc func save() {
        let color = UIColor.hexStringFromColor(color: colorSlider.thumbTintColor ?? .red)
        model.save(text: textView.text,
                   importance: getImportance(),
                   deadline: deadlineSwitch.isOn ?  deadlinePicker.date : nil, color: color)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @objc func deleteItem() {
        model.delete()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @objc func deadlineSwitched() {
        dateButton.isHidden = !deadlineSwitch.isOn
        if deadlineSwitch.isOn {
            deadlineTopAnchorConstraint.constant = 66.5
        } else {
            deadlineTopAnchorConstraint.constant = 73.5
        }
        hideShowDatePicker()
    }
    @objc func hideShowDatePicker() {
        let oldConstraint = stackBottomConstraint.constant
        switch datePickerShown && deadlineSwitch.isOn {
        case true:
            stackBottomConstraint.constant = 128.5 + deadlinePicker.bounds.height
            deadlinePicker.isHidden = false
        case false:
            stackBottomConstraint.constant = 128.5
            deadlinePicker.isHidden = true
        }
        scrollView.contentSize.height += stackBottomConstraint.constant - oldConstraint
    }
    @objc func dateButtonClick() {
        datePickerShown = !datePickerShown
        hideShowDatePicker()
    }
    @objc func dateWasChanged() {
        dateButton.setTitle(deadlinePicker.formattedDate(), for: .normal)
    }
    @objc func colorWasChanged() {
        let trackRect = colorSlider.trackRect(forBounds: colorSlider.bounds)
        let thumbRect = colorSlider.thumbRect(forBounds: colorSlider.bounds, trackRect: trackRect, value:
                                                colorSlider.value)
        let thumbPoint = CGPoint(x: thumbRect.midX, y: thumbRect.midY)
        let color = colorView.getColor(from: thumbPoint)
        colorSlider.thumbTintColor = color
        textView.textColor = color
        textView.tintColor = color
    }
    @objc func hideFieldsInLandscape() {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            colorStack.isHidden = true
            importanceAndDateStack.isHidden = true
            deleteButton.isHidden = true
            scrollView.contentSize = textView.contentSize
        }
    }
    @objc func showFields() {
        colorStack.isHidden = false
        importanceAndDateStack.isHidden = false
        deleteButton.isHidden = false
        setScrollViewContentSize()
    }
}
