//
//  NewToDoViewController.swift
//  ToDoList
//
//  Created by Софья Тимохина on 12.06.2021.
//

import UIKit
import UITextView_Placeholder

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
    var stackBottomConstraint = NSLayoutConstraint()
    var dateButton = UIButton()
    var deadlineTopAnchorConstraint = NSLayoutConstraint()
    var datePickerShown = false
    let deadlineLabel = UILabel()
    let labelImportance = UILabel()
    let colorStack = UIStackView()
    let colorSlider = UISlider()
    let colorView = ColorView()
    let scrollView = UIScrollView()
    init(model: NewToDoModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize.height = scrollView.convert(deleteButton.frame.origin, to: scrollView).y +
            UIViewController.safeAreaHeight()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        self.hideKeyboardWhenTappedAround()
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
                                                UIColor.textGray], for: .normal)
        saveButton?.isEnabled = false
        loadData()
    }
    private func setupView() {
        view = UIView()
        view.backgroundColor = .background
    }
    private func addSubviews() {
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
        // It's like DateTime.Now.
        deadlinePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        importanceAndDateStack.addSubview(deadlinePicker)
        [
            deadlinePicker.leadingAnchor.constraint(equalTo: importanceAndDateStack.leadingAnchor, constant: 16),
            deadlinePicker.trailingAnchor.constraint(equalTo: importanceAndDateStack.trailingAnchor, constant: -16),
            deadlinePicker.topAnchor.constraint(equalTo: importanceAndDateStack.topAnchor, constant: 117)
        ].forEach({$0.isActive = true})
        deadlinePicker.isHidden = true
        deadlinePicker.addTarget(self, action: #selector(dateWasChanged), for: .valueChanged)
        dateButton.setTitle(deadlinePicker.getDate(), for: .normal)
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

extension NewToDoViewController {
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @objc func save() {
        let color = UIColor.hexStringFromColor(color: colorSlider.thumbTintColor ?? .red)
        model.save(text: textView.text, importance: segmentedControl.titleForSegment(at:
        segmentedControl.selectedSegmentIndex) ?? "common", deadline: deadlinePicker.date, color: color)
    }
    @objc func deleteItem() {
        // TODO
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
        dateButton.setTitle(deadlinePicker.getDate(), for: .normal)
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
}

extension NewToDoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let oldConstraint = textBottomAnchorConstraint.constant
        let textHeight = self.textView.sizeThatFits(self.textView.bounds.size).height + 20
        self.textBottomAnchorConstraint.constant = max(136, textHeight)
        scrollView.contentSize.height += textBottomAnchorConstraint.constant - oldConstraint
        setupVisability()
    }
    func setupVisability() {
        if textView.text.isEmpty || textView.text == "" {
            deleteButton.isEnabled = false
            // It hides this bar batton and I don't understand why. Is it a bug?
            saveButton?.isEnabled = false
            saveButton?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                                                    UIColor.textGray], for: .normal)
            deleteButton.setTitleColor(.textGray, for: .normal)
        } else {
            saveButton?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
            deleteButton.setTitleColor(#colorLiteral(red: 0.8694987297, green: 0, blue: 0.2487540245, alpha: 1), for: .normal)
            deleteButton.isEnabled = true
            saveButton?.isEnabled = true
        }
    }
}

extension NewToDoViewController {
    func loadData() {
        textView.text = model.toDoItem.text
        if let deadline = model.toDoItem.deadline {
            deadlineSwitch.isOn = true
            deadlinePicker.minimumDate = min(Date(), deadline)
            deadlinePicker.date = deadline
        }
        segmentedControl.selectedSegmentIndex =
            ["unimportant", "common", "important"].firstIndex(of: model.toDoItem.importance.rawValue) ?? 0
        let color = UIColor.colorWithHexString(hexString: model.toDoItem.color)
        textView.textColor = color
        colorSlider.thumbTintColor = color
    }
}
