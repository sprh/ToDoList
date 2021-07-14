//
//  NewItemView.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import Foundation
import UIKit

final class NewItemView: UIViewController {
    let presenter: NewItemPresenter!
    var scrollView: UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    var textView: UITextView {
        let textView = UITextView()
        textView.backgroundColor = .subviewsBackground
        textView.layer.cornerRadius = 16
        textView.placeholder = "What do you have to do?".localized
        textView.font = .body
        textView.textColor = .text
        textView.placeholderColor = .textGray
        textView.isScrollEnabled = false
//        textView.delegate = self
        textBottomAnchorConstraint = textView.bottomAnchor.constraint(equalTo: scrollView.topAnchor,
                                                                      constant: 136)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.tintColor = .text
        return textView
    }
    var textBottomAnchorConstraint = NSLayoutConstraint()
    var importanceAndDateStack: UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .subviewsBackground
        stack.layer.cornerRadius = 16
        importanceAndDateStackBottomConstraint = stack.bottomAnchor.constraint(
            equalTo: colorStack.bottomAnchor, constant: 128.5)
        return stack
    }
    var importanceAndDateStackBottomConstraint = NSLayoutConstraint()
    var deadlineSwitch: UISwitch {
        let deadlineSwitch = UISwitch()
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
//        deadlineSwitch.addTarget(self, action: #selector(deadlineSwitched), for: .valueChanged)
        return deadlineSwitch
    }
    var segmentedControl: UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: ["low", "basic", "important"])
        segmentedControl.setImage(.lowImportance, forSegmentAt: 0)
        segmentedControl.setTitle("non".localized, forSegmentAt: 1)
        segmentedControl.setImage(.highImportance, forSegmentAt: 2)
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }
    var deleteButton: UIButton {
        let button = UIButton()
        button.setTitle("Delete".localized, for: .normal)
        button.backgroundColor = .subviewsBackground
        button.setTitleColor(.textGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
//        button.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        return button
    }
    var cancelButton: UIBarButtonItem?
    var saveButton: UIBarButtonItem?
    var deadlinePicker: UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.backgroundColor = .subviewsBackground
        datePicker.tintColor = .azure
        datePicker.minimumDate = Date()
        datePicker.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        datePicker.isHidden = true
//        datePicker.addTarget(self, action: #selector(dateWasChanged), for: .valueChanged)
        return datePicker
    }
    var dateButton: UIButton {
        let button = UIButton()
        button.setTitle(deadlinePicker.formattedDate(), for: .normal)
        button.setTitleColor(.azure, for: .normal)
        button.titleLabel?.font = .footnote
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
//        dateButton.addTarget(self, action: #selector(dateButtonClick), for: .touchDown)
        return button
    }
    var deadlineTopAnchorConstraint = NSLayoutConstraint()
    var deadlineLabel: UILabel {
        let label = UILabel()
        label.text = "Deadline".localized
        label.font = .body
        label.textColor = .text
        label.translatesAutoresizingMaskIntoConstraints = false
        deadlineTopAnchorConstraint = label.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor,
                                                                         constant: 73.5)
        return label
    }
    var labelImportance: UILabel {
        let label = UILabel()
        label.text = "Importance".localized
        label.font = .body
        label.textColor = .text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    var colorStack: UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        return stack
    }
    var colorSlider: UISlider {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.layer.borderColor = UIColor.blue.cgColor
        return slider
    }
    var colorView: ColorView {
        let view = ColorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor?.withAlphaComponent(0.5)
        view.layer.borderWidth = 2
        return view
    }
    var standartColorButton: UIButton {
        let height = colorSlider.bounds.height
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .text
        button.layer.cornerRadius = height / 2
        button.layer.borderWidth = 2
        return button
    }
    
    var separator: UIView {
        let separator = UIView()
        separator.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
    
    init(presenter: NewItemPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView()
        view.backgroundColor = .background
        addSubviews()
    }
    
    func addSubviews() {
        setupScrollview()
        setupTextView()
        addColorStack()
        setupStack()
        setupDeleteButton()
    }
    
    func setupScrollview() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            textBottomAnchorConstraint
        ])
    }
    
    func addColorStack() {
        let height = colorSlider.bounds.height
        scrollView.addSubview(colorStack)
        NSLayoutConstraint.activate([
            colorStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            colorStack.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorStack.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            colorStack.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: colorSlider.bounds.height + 10)
        ])
        colorStack.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: colorStack.leadingAnchor, constant: 16),
            colorView.trailingAnchor.constraint(equalTo: colorStack.trailingAnchor, constant: -height - 10),
            colorView.topAnchor.constraint(equalTo: colorStack.topAnchor, constant: 8),
            colorView.bottomAnchor.constraint(equalTo: colorStack.topAnchor,
                                              constant: colorSlider.bounds.height - 8)
        ])
        colorStack.addSubview(colorSlider)
        NSLayoutConstraint.activate([
            colorSlider.leadingAnchor.constraint(equalTo: colorStack.leadingAnchor, constant: 11),
            colorSlider.trailingAnchor.constraint(equalTo: colorStack.trailingAnchor, constant: -height - 10),
            colorSlider.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
//        colorSlider.addTarget(self, action: #selector(colorWasChanged), for: .valueChanged)
        colorStack.addSubview(standartColorButton)
        NSLayoutConstraint.activate([
            standartColorButton.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            standartColorButton.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10 + height),
            standartColorButton.centerYAnchor.constraint(equalTo: colorView.centerYAnchor)
        ])
//        standartColorButton.addTarget(self, action: #selector(resetColor), for: .touchUpInside)
//        resetColor()
    }
    
    func setupStack() {
        scrollView.addSubview(importanceAndDateStack)
        NSLayoutConstraint.activate([
            importanceAndDateStack.topAnchor.constraint(equalTo: colorStack.bottomAnchor, constant: 16),
            importanceAndDateStack.leadingAnchor.constraint(equalTo:
            scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            importanceAndDateStack.trailingAnchor.constraint(equalTo:
            scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            importanceAndDateStackBottomConstraint
        ])
        setupImportanceStack()
        setupDeadlineStack()
    }
    
    func setupImportanceStack() {
        importanceAndDateStack.addSubview(labelImportance)
        importanceAndDateStack.addSubview(separator)
        importanceAndDateStack.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            labelImportance.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            labelImportance.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 17)
        ])
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 55.5),
            separator.bottomAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 56)
        ])
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -162),
            segmentedControl.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -12),
            segmentedControl.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 10),
            segmentedControl.bottomAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 46)
        ])
    }
    
    private func setupDeadlineStack() {
        importanceAndDateStack.addSubview(deadlineLabel)
        NSLayoutConstraint.activate([
            deadlineLabel.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            deadlineTopAnchorConstraint
        ])
        importanceAndDateStack.addSubview(deadlineSwitch)
        NSLayoutConstraint.activate([
            deadlineSwitch.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -12),
            deadlineSwitch.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 69),
            deadlineSwitch.bottomAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: -12.5)
        ])
//        deadlineSwitch.addTarget(self, action: #selector(deadlineSwitched), for: .valueChanged)
        importanceAndDateStack.addSubview(deadlinePicker)
        NSLayoutConstraint.activate([
            deadlinePicker.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            deadlinePicker.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -16),
            deadlinePicker.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 117)
        ])
        importanceAndDateStack.addSubview(dateButton)
        NSLayoutConstraint.activate([
            dateButton.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            dateButton.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor)
        ])
//        dateButton.addTarget(self, action: #selector(dateButtonClick), for: .touchDown)
    }
    
    private func setupDeleteButton() {
        scrollView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -16),
            deleteButton.topAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: 16),
            deleteButton.bottomAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: 72)
        ])
//        deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
    }
}

extension NewItemView: NewItemViewDelegate {
}
