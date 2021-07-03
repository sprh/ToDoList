//
//  ToDoTextViewDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 26.06.2021.
//

import UIKit

extension ToDoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(size)
        if size != newSize {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text != "\n" {
            return true
        }
        textView.resignFirstResponder()
        if !textView.text.isEmpty {
            let toDoItem = ToDoItem(text: textView.text,
                                    color: "",
                                    done: false,
                                    updatedAt: nil,
                                    createdAt: Int(Date().timeIntervalSince1970))
            textView.text = ""
            model.addToDoItem(toDoItem: toDoItem)
            tableView.reloadData() }
        return false
    }
}
