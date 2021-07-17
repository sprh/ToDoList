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
    var cancelButton: UIBarButtonItem?
    var saveButton: UIBarButtonItem?
    func view() -> NewItemInterface { self.view as? NewItemInterface ?? NewItemInterface() }
    
    init(presenter: NewItemPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = NewItemInterface()
        setupViewAndAddTargets()
        NotificationCenter.default.addObserver(self, selector: #selector(hideFieldsInLandscape),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showFields),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view().setScrollViewContentSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "To-do".localized
        cancelButton = UIBarButtonItem(title: "Cancel".localized,
                                       style: .plain, target: self, action: #selector(cancel))
        cancelButton?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelButton
        saveButton = UIBarButtonItem(title: "Save".localized, style: .plain, target: self, action: #selector(save))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = saveButton
        saveButton?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                                                UIColor.textGray], for: .normal)
        saveButton?.isEnabled = false
        loadData()
    }
    
    func setupViewAndAddTargets() {
        view().textView.delegate = self
        view().deleteButton.addTarget(self, action: #selector(delete), for: .touchUpInside)
        view().dateButton.addTarget(self, action: #selector(dateButtonClick), for: .touchDown)
        view().deadlinePicker.addTarget(self, action: #selector(dateWasChanged), for: .valueChanged)
        view().deadlineSwitch.addTarget(self, action: #selector(deadlineSwitched), for: .valueChanged)
        view().standartColorButton.addTarget(self, action: #selector(resetColor), for: .touchUpInside)
        view().colorSlider.addTarget(self, action: #selector(colorWasChanged), for: .valueChanged)
    }
    
    func hideShowDatePicker() {
        let oldConstraint = view().stackBottomConstraint.constant
        if presenter.datePickerShown && view().deadlineSwitch.isOn {
            view().stackBottomConstraint.constant = 128.5 + view().deadlinePicker.bounds.height
            view().deadlinePicker.isHidden = false
        } else {
            view().stackBottomConstraint.constant = 128.5
            view().deadlinePicker.isHidden = true
        }
        view().scrollView.contentSize.height += view().stackBottomConstraint.constant - oldConstraint
    }
    
    func loadData() {
        presenter.getData()
    }
}

extension NewItemView: NewItemViewDelegate {
    func loadData(_ data: (text: String, importance: Int, deadline: Int?, color: String?)) {
        view().textView.text = data.text
        view().segmentedControl.selectedSegmentIndex = data.importance
        if let deadline = data.deadline {
            view().deadlineSwitch.isOn = true
            deadlineSwitched()
            view().deadlinePicker.minimumDate = Date.init(timeIntervalSince1970: Double(deadline))
            view().deadlinePicker.date = Date.init(timeIntervalSince1970: Double(deadline))
            view().dateButton.setTitle(view().deadlinePicker.formattedDate(), for: .normal)
        }
        setupVisibility()
        textViewDidChange(view().textView)
        colorWasChanged()
        if let hexString = data.color {
            let color = UIColor.colorWithHexString(hexString: hexString)
            view().colorSlider.value = view().colorView.getValue(color: color)
            colorWasChanged()
        } else {
            resetColor()
        }
    }
    
}

extension NewItemView {
    @objc func hideFieldsInLandscape() {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            view().hideFieldsInLandscape()
        } else {
            view().setScrollViewContentSize()
        }
    }
    
    @objc func showFields() {
        view().showFields()
    }
    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        let color = presenter.standartColor ? nil :
            UIColor.hexStringFromColor(color: view().colorSlider.thumbTintColor!)
        let deadline = presenter.datePickerShown ? (Int)(view().deadlinePicker.date.timeIntervalSince1970) : nil
        presenter.save(text: view().textView.text,
                       importance: view().segmentedControl.selectedSegmentIndex,
                       deadline: deadline,
                       color: color)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc override func delete(_ sender: Any?) {
        presenter.delete()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dateButtonClick() {
        presenter.datePickerShown.toggle()
    }
    
    @objc func dateWasChanged() {
        view().dateButton.setTitle(view().deadlinePicker.formattedDate(), for: .normal)
    }
    
    @objc func deadlineSwitched() {
        view().dateButton.isHidden = !view().deadlineSwitch.isOn
        if view().deadlineSwitch.isOn {
            view().deadlineTopAnchorConstraint.constant = 66.5
        } else {
            view().deadlineTopAnchorConstraint.constant = 73.5
        }
        hideShowDatePicker()
    }
    
    @objc func resetColor() {
        presenter.standartColor = true
        let color = UIColor.text
        view().textView.textColor = color
        view().textView.tintColor = color
        view().standartColorButton.layer.borderColor = UIColor.textGray.cgColor
        view().colorView.layer.borderColor = UIColor.clear.cgColor
    }
    
    @objc func colorWasChanged() {
        presenter.standartColor = false
        let color = view().colorView.getColor(value: view().colorSlider.value)
        view().colorSlider.thumbTintColor = color
        view().textView.textColor = color
        view().textView.tintColor = color
        view().colorView.layer.borderColor = UIColor.text.cgColor
        view().standartColorButton.layer.borderColor = UIColor.clear.cgColor
    }
}

extension NewItemView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let oldConstraint = view().textBottomAnchorConstraint.constant
        let textHeight = view().textView.sizeThatFits(view().textView.bounds.size).height + 20
        view().textBottomAnchorConstraint.constant = max(136, textHeight)
        view().scrollView.contentSize.height += view().textBottomAnchorConstraint.constant - oldConstraint
        setupVisibility()
    }
    
    func setupVisibility() {
        if view().textView.text.isEmpty || view().textView.text == "" {
            view().deleteButton.isEnabled = false
            saveButton?.isEnabled = false
            saveButton?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                                                    UIColor.textGray], for: .normal)
            view().deleteButton.setTitleColor(.textGray, for: .normal)
        } else {
            saveButton?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
            view().deleteButton.setTitleColor(#colorLiteral(red: 0.8694987297, green: 0, blue: 0.2487540245, alpha: 1), for: .normal)
            view().deleteButton.isEnabled = true
            saveButton?.isEnabled = true
        }
    }
}
