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
                   color: standartColor ? nil : color)
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
        standartColor = false
        let color = colorView.getColor(value: colorSlider.value)
        colorSlider.thumbTintColor = color
        textView.textColor = color
        textView.tintColor = color
        colorView.layer.borderColor = UIColor.text.cgColor
        standartColorButton.layer.borderColor = UIColor.clear.cgColor
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
    @objc func resetColor() {
        standartColor = true
        let color = UIColor.text
        textView.textColor = color
        textView.tintColor = color
        standartColorButton.layer.borderColor = UIColor.textGray.cgColor
        colorView.layer.borderColor = UIColor.clear.cgColor
    }
}
