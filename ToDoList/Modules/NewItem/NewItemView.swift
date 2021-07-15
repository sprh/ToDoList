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
    func view() -> NewItemInterface? {
        self.view as? NewItemInterface
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
        view = NewItemInterface()
        view()?.textView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(hideFieldsInLandscape),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showFields),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view()?.setScrollViewContentSize()
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
    }
}

extension NewItemView: NewItemViewDelegate {
}

extension NewItemView {
    @objc func hideFieldsInLandscape() {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            view()?.hideFieldsInLandscape()
        } else {
            view()?.setScrollViewContentSize()
        }
    }
    
    @objc func showFields() {
        view()?.showFields()
    }
    
    @objc func cancel() {
        
    }
    
    @objc func save() {
        guard let view = view() else { return }
        let color = presenter.standartColor ? nil : UIColor.hexStringFromColor(color: view.colorSlider.thumbTintColor!)
        let deadline = presenter.datePickerShown ? (Int)(view.deadlinePicker.date.timeIntervalSince1970) : nil
        presenter.save(text: view.textView.text,
                       importance: view.segmentedControl.selectedSegmentIndex,
                       deadline: deadline,
                       color: color)
        
    }
}

extension NewItemView: UITextViewDelegate {
}
