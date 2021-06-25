//
//  ViewController.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.06.2021.
//

import UIKit

extension UIViewController {
    static func safeAreaHeight() -> CGFloat {
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        return topPadding + bottomPadding
    }
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
