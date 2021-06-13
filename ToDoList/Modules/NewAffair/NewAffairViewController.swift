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
    var importanceAndDeadlineTableView = UITableView()
    var deadlineLabelConstraint = NSLayoutConstraint()
    let dateLabel = UIButton()
    var datePickerCellIndexPath: IndexPath?
    var tableViewBottomConstraint = NSLayoutConstraint()
    var datePickerShown = false
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
        addTableView()
    }
    private func setupTextField() {
        textBottomAnchorConstraint = textView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 192)
        textView.backgroundColor = .subviewsBackgtoundColor
        textView.layer.cornerRadius = 16
        textView.font = .body
        textView.isScrollEnabled = true
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
    private func addTableView() {
        importanceAndDeadlineTableView.translatesAutoresizingMaskIntoConstraints = false
        importanceAndDeadlineTableView.dataSource = self
        importanceAndDeadlineTableView.delegate = self
        importanceAndDeadlineTableView.allowsSelection = false
        importanceAndDeadlineTableView.delaysContentTouches = false
        importanceAndDeadlineTableView.layer.cornerRadius = 16
        tableViewBottomConstraint = importanceAndDeadlineTableView.bottomAnchor.constraint(equalTo:
                                    textView.bottomAnchor, constant: 208)
        view.addSubview(importanceAndDeadlineTableView)
        [
            importanceAndDeadlineTableView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            importanceAndDeadlineTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            importanceAndDeadlineTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewBottomConstraint
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
        switch deadlineSwitch.isOn {
        case true:
            dateLabel.isHidden = false
            deadlineLabelConstraint.constant = 9
            hideShowDatePickerCell()
        case false:
            dateLabel.isHidden = true
            deadlineLabelConstraint.constant = 17
            datePickerShown = false
            hideShowDatePickerCell()
        }
        view.layoutIfNeeded()
    }
    @objc func hideShowDatePicker() {
        datePickerShown = !datePickerShown
        hideShowDatePickerCell()
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

extension NewToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datePickerShown ? 3 : 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getImportanceCell()
        case 1:
            return getDeadlineCell()
        case 2:
            datePickerCellIndexPath = indexPath
            return getDatePickerCell()
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerCellIndexPath != nil && indexPath == datePickerCellIndexPath {
            if datePickerShown {
                return deadlinePicker.bounds.height
            } else {
                return .zero
            }
        }
        return UITableView.automaticDimension
    }
    private func hideShowDatePickerCell() {
        importanceAndDeadlineTableView.reloadData()
        guard let index = datePickerCellIndexPath,
              let cell = importanceAndDeadlineTableView.cellForRow(at: index) else {
            return
        }
        cell.isHidden = datePickerShown
        if !datePickerShown {
            cell.frame.size.height = .zero
//            tableViewBottomConstraint.constant = importanceAndDeadlineTableView.contentSize.height + 72 + deadlinePicker.bounds.height
        } else {
            cell.frame.size.height = deadlinePicker.bounds.height
        }
        print(importanceAndDeadlineTableView.contentSize.height)
    }
    private func getImportanceCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.contentView.isUserInteractionEnabled = true
        let labelImportance = UILabel()
        labelImportance.text = NSLocalizedString("Importance", comment: "")
        labelImportance.font = .body
        labelImportance.textColor = .textColor
        labelImportance.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(labelImportance)
        [
            labelImportance.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            labelImportance.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 17)
        ].forEach({$0.isActive = true})
        segmentedControl.setImage(.lowImportance, forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("non", comment: ""), forSegmentAt: 1)
        segmentedControl.setImage(.highImportance, forSegmentAt: 2)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 1
        cell.contentView.addSubview(segmentedControl)
        [
            segmentedControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -12),
            segmentedControl.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            segmentedControl.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
        ].forEach({$0.isActive = true})
        return cell
    }
    private func getDeadlineCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.contentView.isUserInteractionEnabled = true
        let deadlineLabel = UILabel()
        deadlineLabelConstraint = deadlineLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 17)
        deadlineLabel.text = NSLocalizedString("Deadline", comment: "")
        deadlineLabel.font = .body
        deadlineLabel.textColor = .textColor
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(deadlineLabel)
        [
            deadlineLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            deadlineLabelConstraint
        ].forEach({$0.isActive = true})
        // MARK: - Separator for the stack.
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(deadlineSwitch)
        [
            deadlineSwitch.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -12),
            deadlineSwitch.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12.5),
            deadlineSwitch.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12.5)
        ].forEach({$0.isActive = true})
        deadlineSwitch.addTarget(self, action: #selector(deadlineSwitched), for: .valueChanged)
        dateLabel.setTitle("Deadline 1", for: .normal)
        dateLabel.setTitleColor(#colorLiteral(red: 0.01058180071, green: 0.4768913388, blue: 0.9985166192, alpha: 1), for: .normal)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.isHidden = true
        cell.contentView.addSubview(dateLabel)
        [
            dateLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 31)
        ].forEach({$0.isActive = true})
        dateLabel.titleLabel?.font = .footnote
        dateLabel.addTarget(self, action: #selector(hideShowDatePicker), for: .touchDown)
        return cell
    }
    private func getDatePickerCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.contentView.isUserInteractionEnabled = true
        deadlinePicker.translatesAutoresizingMaskIntoConstraints = false
        deadlinePicker.datePickerMode = .date
        deadlinePicker.preferredDatePickerStyle = .inline
        cell.contentView.addSubview(deadlinePicker)
        [
            deadlinePicker.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -12),
            deadlinePicker.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12.5),
            deadlinePicker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 12)
        ].forEach({$0.isActive = true})
        cell.contentView.bounds.size.height = deadlinePicker.bounds.height
        cell.isHidden = true
        cell.layoutIfNeeded()
        return cell
    }
}
