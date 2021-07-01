//
//  NewToDoTextViewDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 26.06.2021.
//

import UIKit

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
