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
    var segmentedControl = UISegmentedControl(items: ["low", "basic", "important"])
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
    let importanceAsArray = ["low", "basic", "important"]
    let standartColorButton = UIButton()
    var standartColor: Bool = false
    init(model: NewToDoModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideFieldsInLandscape),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showFields),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setScrollViewContentSize()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        hideKeyboardWhenTappedAround()
        keyboardWillShow(scrollView)
        keyboardWillHide(scrollView)
        setScrollViewContentSize()
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
}
