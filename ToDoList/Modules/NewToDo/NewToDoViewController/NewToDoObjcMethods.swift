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
                   deadline: deadlineSwitch.isOn ?  deadlinePicker.date : nil,
                   color: color)
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
        datePickerShown.toggle()
        hideShowDatePicker()
    }
    @objc func dateWasChanged() {
        dateButton.setTitle(deadlinePicker.formattedDate(), for: .normal)
    }
    @objc func colorWasChanged() {
        let color = UIColor(hue: CGFloat(colorSlider.value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
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
        } else {
            setScrollViewContentSize()
        }
    }
    @objc func showFields() {
        colorStack.isHidden = false
        importanceAndDateStack.isHidden = false
        deleteButton.isHidden = false
        setScrollViewContentSize()
    }
}
