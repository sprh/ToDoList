//
//  NewToDoCell.swift
//  ToDoList
//
//  Created by Софья Тимохина on 25.06.2021.
//

import UIKit
import UITextView_Placeholder
import Models

/// NewToDoCell is the last cell in the tableview on the ToDoView screen.
/// This cell is used to add a new to do item without opening another screen.
final class NewToDoCell: UITableViewCell {
    weak var delegate: ItemsListViewDelegate?
    var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .subviewsBackground
        textView.layer.cornerRadius = 16
        textView.placeholder = "New".localized
        textView.font = .body
        textView.textColor = .text
        textView.placeholderColor = .textGray
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .subviewsBackground
        selectionStyle = .none
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -16)
        ])
        textView.delegate = self
    }
}

extension NewToDoCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(size)
        if size != newSize {
            guard let tableView = superview as? UITableView else { return }
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
            delegate?.addItem(toDoItem)
        }
        return false
    }
}
