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
        NotificationCenter.default.addObserver(self, selector: #selector(hideFieldsInLandscape),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showFields),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
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
}
