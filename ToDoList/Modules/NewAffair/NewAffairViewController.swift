//
//  NewToDoViewController.swift
//  ToDoList
//
//  Created by Софья Тимохина on 12.06.2021.
//

import UIKit

class NewToDoViewController: UIViewController {
    var model: NewToDoModel!
    var textView = UITextView()
    var textBottomAnchorConstraint = NSLayoutConstraint()
    var importanceAndDateStack = UIStackView()
    var deadlineSwitch = UISwitch()
    var segmentedControl = UISegmentedControl(items: ["unimportant", "common", "important"])
    var deleteButton = UIButton()
    var cancelButton: UIBarButtonItem?
    var saveButton: UIBarButtonItem?
    var deadlinePicker = UIDatePicker()
    init(model: NewToDoModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = false
        title = NSLocalizedString("To-do", comment: "")
        cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel",
                        comment: ""), style: .plain, target: self, action: #selector(cancel))
        cancelButton?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelButton
        saveButton = UIBarButtonItem(title: NSLocalizedString("Save",
                        comment: ""), style: .plain, target: self, action: #selector(save))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = saveButton
        saveButton?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                                                UIColor.textGrayColor], for: .normal)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    private func setupView() {
        view = UIView()
        view.backgroundColor = .background
    }
    private func addSubviews() {
        setupTextField()
        setupStack()
        //setupDeleteButton()
    }
    private func setupTextField() {
        textBottomAnchorConstraint = textView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 192)
        textView.backgroundColor = .subviewsBackgtoundColor
        textView.layer.cornerRadius = 16
        textView.font = .body
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        [
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72),
            textBottomAnchorConstraint
        ].forEach({$0.isActive = true})
    }
    private func setupStack() {
        importanceAndDateStack.translatesAutoresizingMaskIntoConstraints = false
        importanceAndDateStack.backgroundColor = .subviewsBackgtoundColor
        importanceAndDateStack.layer.cornerRadius = 16
        view.addSubview(importanceAndDateStack)
        [
            importanceAndDateStack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            importanceAndDateStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            importanceAndDateStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            importanceAndDateStack.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 128.5)
        ].forEach({$0.isActive = true})
        setupImportanceStack()
        setupDeadlineStack()
    }
    private func setupImportanceStack() {
        let labelImportance = UILabel()
        labelImportance.text = NSLocalizedString("Importance", comment: "")
        labelImportance.font = .body
        labelImportance.textColor = .textColor
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
            segmentedControl.bottomAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: -66.5)
        ].forEach({$0.isActive = true})
    }
    private func setupDeadlineStack() {
        // MARK: - Labels for the stack.
        let deadlineLabel = UILabel()
        deadlineLabel.text = NSLocalizedString("Deadline", comment: "")
        deadlineLabel.font = .body
        deadlineLabel.textColor = .textColor
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        importanceAndDateStack.addSubview(deadlineLabel)
        [
            deadlineLabel.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            deadlineLabel.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 73.5)
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
//        deadlinePicker.datePickerMode = .date
        deadlinePicker.preferredDatePickerStyle = .inline
        view.addSubview(deadlinePicker)
        [
            deadlinePicker.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            deadlinePicker.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -16),
            deadlinePicker.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 88.5)
        ].forEach({$0.isActive = true})
    }
    private func setupDeleteButton() {
        deleteButton.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
        deleteButton.backgroundColor = .subviewsBackgtoundColor
        deleteButton.setTitleColor(.textGrayColor, for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.layer.cornerRadius = 16
        view.addSubview(deleteButton)
        [
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteButton.topAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: 16),
            deleteButton.bottomAnchor.constraint(equalTo: importanceAndDateStack.bottomAnchor, constant: 72)
        ].forEach({$0.isActive = true})
    }
}

extension NewToDoViewController {
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @objc func save() {
        // TODO: add it
    }
    @objc func deadlineSwitched() {
        // deadlinePicker.isEnabled = deadlineSwitch.isOn
    }
}

extension NewToDoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let textHeight = self.textView.sizeThatFits(self.textView.bounds.size).height
        textBottomAnchorConstraint.constant = max(192, textHeight)
        setupVisability()
    }
    func setupVisability() {
        if textView.text.isEmpty || textView.text == "" {
            deleteButton.isEnabled = false
            saveButton?.isEnabled = false
            saveButton?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                                                    UIColor.textGrayColor], for: .normal)
            deleteButton.setTitleColor(.textGrayColor, for: .normal)
        } else {
            saveButton?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
            deleteButton.setTitleColor(#colorLiteral(red: 0.8694987297, green: 0, blue: 0.2487540245, alpha: 1), for: .normal)
            deleteButton.isEnabled = true
            saveButton?.isEnabled = true
        }
    }
}
