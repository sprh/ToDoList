//
//  NewItemInterface.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import UIKit

final class NewItemInterface: UIView {
    var textView = UITextView()
    var textBottomAnchorConstraint = NSLayoutConstraint()
    var importanceAndDateStack = UIStackView()
    var deadlineSwitch = UISwitch()
    var segmentedControl = UISegmentedControl(items: ["low", "basic", "important"])
    var deleteButton = UIButton()
    var deadlinePicker = UIDatePicker()
    var stackBottomConstraint = NSLayoutConstraint()
    var dateButton = UIButton()
    var deadlineTopAnchorConstraint = NSLayoutConstraint()
    let deadlineLabel = UILabel()
    let labelImportance = UILabel()
    let colorStack = UIStackView()
    let colorSlider = UISlider()
    let colorView = ColorView()
    let scrollView = UIScrollView()
    let standartColorButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addColorStack() {
        let height = colorSlider.bounds.height
        colorStack.translatesAutoresizingMaskIntoConstraints = false
        colorStack.backgroundColor = .clear
        scrollView.addSubview(colorStack)
        NSLayoutConstraint.activate([
            colorStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            colorStack.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorStack.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            colorStack.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: colorSlider.bounds.height + 10)
        ])
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor?.withAlphaComponent(0.5)
        colorView.layer.borderWidth = 2
        colorStack.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: colorStack.leadingAnchor, constant: 16),
            colorView.trailingAnchor.constraint(equalTo: colorStack.trailingAnchor, constant: -height - 10),
            colorView.topAnchor.constraint(equalTo: colorStack.topAnchor, constant: 8),
            colorView.bottomAnchor.constraint(equalTo: colorStack.topAnchor,
                                              constant: colorSlider.bounds.height - 8)
        ])
        colorSlider.translatesAutoresizingMaskIntoConstraints = false
        colorSlider.minimumTrackTintColor = .clear
        colorSlider.maximumTrackTintColor = .clear
        colorSlider.layer.borderColor = UIColor.blue.cgColor
        colorStack.addSubview(colorSlider)
        NSLayoutConstraint.activate([
            colorSlider.leadingAnchor.constraint(equalTo: colorStack.leadingAnchor, constant: 11),
            colorSlider.trailingAnchor.constraint(equalTo: colorStack.trailingAnchor, constant: -height - 10),
            colorSlider.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
        standartColorButton.translatesAutoresizingMaskIntoConstraints = false
        standartColorButton.backgroundColor = .text
        colorStack.addSubview(standartColorButton)
        standartColorButton.layer.cornerRadius = height / 2
        standartColorButton.layer.borderWidth = 2
        NSLayoutConstraint.activate([
            standartColorButton.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            standartColorButton.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10 + height),
            standartColorButton.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
    }
    
    private func setupTextField() {
        textBottomAnchorConstraint = textView.bottomAnchor.constraint(equalTo: scrollView.topAnchor,
                                                                      constant: 136)
        textView.backgroundColor = .subviewsBackground
        textView.layer.cornerRadius = 16
        textView.placeholder = "What do you have to do?".localized
        textView.font = .body
        textView.textColor = .text
        textView.placeholderColor = .textGray
        textView.isScrollEnabled = false
//        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            textBottomAnchorConstraint
        ])
        textView.tintColor = .text
        textView.accessibilityIdentifier = AccessibilityIdentifiers.NewItem.textView
    }
    
    private func setupStack() {
        importanceAndDateStack.translatesAutoresizingMaskIntoConstraints = false
        importanceAndDateStack.backgroundColor = .subviewsBackground
        importanceAndDateStack.layer.cornerRadius = 16
        stackBottomConstraint = importanceAndDateStack.bottomAnchor.constraint(equalTo:
                                colorStack.bottomAnchor, constant: 128.5)
        scrollView.addSubview(importanceAndDateStack)
        NSLayoutConstraint.activate([
            importanceAndDateStack.topAnchor.constraint(equalTo: colorStack.bottomAnchor, constant: 16),
            importanceAndDateStack.leadingAnchor.constraint(equalTo:
            scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            importanceAndDateStack.trailingAnchor.constraint(equalTo:
            scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackBottomConstraint
        ])
        setupImportanceStack()
        setupDeadlineStack()
    }
    
    private func setupImportanceStack() {
        labelImportance.text = "Importance".localized
        labelImportance.font = .body
        labelImportance.textColor = .text
        labelImportance.translatesAutoresizingMaskIntoConstraints = false
        importanceAndDateStack.addSubview(labelImportance)
        NSLayoutConstraint.activate([
            labelImportance.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            labelImportance.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 17)
        ])
        let separator = UIView()
        importanceAndDateStack.addSubview(separator)
        separator.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 55.5),
            separator.bottomAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 56)
        ])
        segmentedControl.accessibilityIdentifier = AccessibilityIdentifiers.NewItem.segmentedControl
        segmentedControl.setImage(.lowImportance, forSegmentAt: 0)
        segmentedControl.setTitle("non".localized, forSegmentAt: 1)
        segmentedControl.setImage(.highImportance, forSegmentAt: 2)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 1
        importanceAndDateStack.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -162),
            segmentedControl.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -12),
            segmentedControl.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 10),
            segmentedControl.bottomAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 46)
        ])
    }
    
    private func setupDeadlineStack() {
        deadlineLabel.text = "Deadline".localized
        deadlineLabel.font = .body; deadlineLabel.textColor = .text
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineTopAnchorConstraint = deadlineLabel.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor,
                                                                         constant: 73.5)
        importanceAndDateStack.addSubview(deadlineLabel)
        NSLayoutConstraint.activate([
            deadlineLabel.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            deadlineTopAnchorConstraint
        ])
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
        deadlineSwitch.accessibilityIdentifier = AccessibilityIdentifiers.NewItem.deadlineSwitch
        importanceAndDateStack.addSubview(deadlineSwitch)
        NSLayoutConstraint.activate([
            deadlineSwitch.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -12),
            deadlineSwitch.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 69),
            deadlineSwitch.bottomAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: -12.5)
        ])
        deadlinePicker.accessibilityIdentifier = AccessibilityIdentifiers.NewItem.deadlinePicker
        deadlinePicker.translatesAutoresizingMaskIntoConstraints = false
        deadlinePicker.datePickerMode = .date
        deadlinePicker.preferredDatePickerStyle = .inline
        deadlinePicker.backgroundColor = .subviewsBackground
        deadlinePicker.tintColor = .azure
        deadlinePicker.minimumDate = Date()
        deadlinePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        importanceAndDateStack.addSubview(deadlinePicker)
        NSLayoutConstraint.activate([
            deadlinePicker.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            deadlinePicker.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -16),
            deadlinePicker.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 117)
        ])
        deadlinePicker.isHidden = true
        dateButton.accessibilityIdentifier = AccessibilityIdentifiers.NewItem.dateButton
        dateButton.setTitle(deadlinePicker.formattedDate(), for: .normal)
        dateButton.setTitleColor(.azure, for: .normal)
        dateButton.titleLabel?.font = .footnote
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        importanceAndDateStack.addSubview(dateButton)
        NSLayoutConstraint.activate([
            dateButton.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            dateButton.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor)
        ])
        dateButton.isHidden = true
    }
    
    func setupDeleteButton() {
        deleteButton.accessibilityIdentifier = AccessibilityIdentifiers.NewItem.deleteButton
        deleteButton.setTitle("Delete".localized, for: .normal)
        deleteButton.backgroundColor = .subviewsBackground
        deleteButton.setTitleColor(.textGray, for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.layer.cornerRadius = 16
        scrollView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -16),
            deleteButton.topAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: 16),
            deleteButton.bottomAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: 72)
        ])
    }

    func hideFieldsInLandscape() {
        importanceAndDateStack.isHidden = true
        colorStack.isHidden = true
        deleteButton.isHidden = true
        scrollView.contentSize = textView.contentSize
    }
    
    func showFields() {
        importanceAndDateStack.isHidden = false
        colorStack.isHidden = false
        deleteButton.isHidden = false
    }
    
    func setScrollViewContentSize() {
        scrollView.contentSize.height = scrollView.convert(deleteButton.frame.origin, to: scrollView).y +
            UIViewController.safeAreaHeight() + UIViewController.safeAreaHeight()
    }
}
