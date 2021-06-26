//
//  NewToDoAddSubviews.swift
//  ToDoList
//
//  Created by Софья Тимохина on 26.06.2021.
//

import UIKit

extension NewToDoViewController {
    func setScrollViewContentSize() {
        scrollView.contentSize.height = scrollView.convert(deleteButton.frame.origin, to: scrollView).y +
            UIViewController.safeAreaHeight() + UIViewController.safeAreaHeight()
        print(scrollView.contentSize.height)
    }
    func setupView() {
        view = UIView()
        view.backgroundColor = .background
    }
    func addSubviews() {
        setupScrollview()
        setupTextField()
        addColorStack()
        setupStack()
        setupDeleteButton()
    }
    private func setupScrollview() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].forEach({$0.isActive = true})
    }
    private func addColorStack() {
        colorStack.translatesAutoresizingMaskIntoConstraints = false
        colorStack.backgroundColor = .clear
        colorStack.layer.cornerRadius = 16
        scrollView.addSubview(colorStack)
        [
            colorStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            colorStack.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorStack.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            colorStack.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: colorSlider.bounds.height + 10)
        ].forEach({$0.isActive = true})
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor?.withAlphaComponent(0.5)
        colorStack.addSubview(colorView)
        [
            colorView.leadingAnchor.constraint(equalTo: colorStack.leadingAnchor, constant: 16),
            colorView.trailingAnchor.constraint(equalTo: colorStack.trailingAnchor, constant: -16),
            colorView.topAnchor.constraint(equalTo: colorStack.topAnchor, constant: 8),
            colorView.bottomAnchor.constraint(equalTo: colorStack.topAnchor,
                                              constant: colorSlider.bounds.height - 8)
        ].forEach({$0.isActive = true})
        colorSlider.translatesAutoresizingMaskIntoConstraints = false
        colorSlider.minimumTrackTintColor = .clear
        colorSlider.maximumTrackTintColor = .clear
        colorStack.addSubview(colorSlider)
        [
            colorSlider.leadingAnchor.constraint(equalTo: colorStack.leadingAnchor, constant: 11),
            colorSlider.trailingAnchor.constraint(equalTo: colorStack.trailingAnchor, constant: -11),
            colorSlider.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ].forEach({$0.isActive = true})
        colorSlider.addTarget(self, action: #selector(colorWasChanged), for: .valueChanged)
        colorWasChanged()
    }
    private func setupTextField() {
        textBottomAnchorConstraint = textView.bottomAnchor.constraint(equalTo: scrollView.topAnchor,
                                                                      constant: 136)
        textView.backgroundColor = .subviewsBackgtound
        textView.layer.cornerRadius = 16
        textView.placeholder = NSLocalizedString("What do you have to do?", comment: "")
        textView.font = .body
        textView.textColor = .text
        textView.placeholderColor = .textGray
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textView)
        [
            textView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            textBottomAnchorConstraint
        ].forEach({$0.isActive = true})
        textView.tintColor = .text
    }
    private func setupStack() {
        importanceAndDateStack.translatesAutoresizingMaskIntoConstraints = false
        importanceAndDateStack.backgroundColor = .subviewsBackgtound
        importanceAndDateStack.layer.cornerRadius = 16
        stackBottomConstraint = importanceAndDateStack.bottomAnchor.constraint(equalTo:
                                                 colorStack.bottomAnchor, constant: 128.5)
        scrollView.addSubview(importanceAndDateStack)
        [
            importanceAndDateStack.topAnchor.constraint(equalTo: colorStack.bottomAnchor, constant: 16),
            importanceAndDateStack.leadingAnchor.constraint(equalTo:
                    scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            importanceAndDateStack.trailingAnchor.constraint(equalTo:
                    scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackBottomConstraint
        ].forEach({$0.isActive = true})
        setupImportanceStack()
        setupDeadlineStack()
    }
    private func setupImportanceStack() {
        labelImportance.text = NSLocalizedString("Importance", comment: "")
        labelImportance.font = .body
        labelImportance.textColor = .text
        labelImportance.translatesAutoresizingMaskIntoConstraints = false
        importanceAndDateStack.addSubview(labelImportance)
        [
            labelImportance.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            labelImportance.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 17)
        ].forEach({$0.isActive = true})
        let separator = UIView()
        importanceAndDateStack.addSubview(separator)
        separator.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        [
            separator.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 55.5),
            separator.bottomAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 56)
        ].forEach({$0.isActive = true})
        segmentedControl.setImage(.lowImportance, forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("non", comment: ""), forSegmentAt: 1)
        segmentedControl.setImage(.highImportance, forSegmentAt: 2)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 1
        importanceAndDateStack.addSubview(segmentedControl)
        [
            segmentedControl.leadingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -162),
            segmentedControl.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -12),
            segmentedControl.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 10),
            segmentedControl.bottomAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 46)
        ].forEach({$0.isActive = true})
    }
    private func setupDeadlineStack() {
        // MARK: - Labels for the stack.
        deadlineLabel.text = NSLocalizedString("Deadline", comment: "")
        deadlineLabel.font = .body
        deadlineLabel.textColor = .text
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineTopAnchorConstraint = deadlineLabel.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor,
                                                                         constant: 73.5)
        importanceAndDateStack.addSubview(deadlineLabel)
        [
            deadlineLabel.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            deadlineTopAnchorConstraint
        ].forEach({$0.isActive = true})
        // MARK: - Separator for the stack.
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
        importanceAndDateStack.addSubview(deadlineSwitch)
        [
            deadlineSwitch.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -12),
            deadlineSwitch.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 69),
            deadlineSwitch.bottomAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: -12.5)
        ].forEach({$0.isActive = true})
        deadlineSwitch.addTarget(self, action: #selector(deadlineSwitched), for: .valueChanged)
        deadlinePicker.translatesAutoresizingMaskIntoConstraints = false
        deadlinePicker.datePickerMode = .date
        deadlinePicker.preferredDatePickerStyle = .inline
        deadlinePicker.backgroundColor = .subviewsBackgtound
        deadlinePicker.tintColor = .azure
        deadlinePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        importanceAndDateStack.addSubview(deadlinePicker)
        [
            deadlinePicker.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            deadlinePicker.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -16),
            deadlinePicker.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 117)
        ].forEach({$0.isActive = true})
        deadlinePicker.isHidden = true
        deadlinePicker.addTarget(self, action: #selector(dateWasChanged), for: .valueChanged)
        dateButton.setTitle(deadlinePicker.formattedDate(), for: .normal)
        dateButton.setTitleColor(.azure, for: .normal)
        dateButton.titleLabel?.font = .footnote
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        importanceAndDateStack.addSubview(dateButton)
        [
            dateButton.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            dateButton.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor)
        ].forEach({$0.isActive = true})
        dateButton.isHidden = true
        dateButton.addTarget(self, action: #selector(dateButtonClick), for: .touchDown)
    }
    private func setupDeleteButton() {
        deleteButton.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
        deleteButton.backgroundColor = .subviewsBackgtound
        deleteButton.setTitleColor(.textGray, for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.layer.cornerRadius = 16
        scrollView.addSubview(deleteButton)
        [
            deleteButton.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -16),
            deleteButton.topAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: 16),
            deleteButton.bottomAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: 72)
        ].forEach({$0.isActive = true})
        deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
    }
}
