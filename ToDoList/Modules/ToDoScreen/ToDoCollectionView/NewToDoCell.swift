//
//  NewToDoCell.swift
//  ToDoList
//
//  Created by Софья Тимохина on 25.06.2021.
//

import UIKit
import UITextView_Placeholder

/// NewToDoCell is the last cell in the tableview on the ToDoView screen.
/// This cell is used to add a new to do item without opening another screen.
final class NewToDoCell: UITableViewCell {
    let textView = UITextView()
    var textBottomAnchorConstraint = NSLayoutConstraint()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .subviewsBackgtound
        selectionStyle = .none
        addSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubviews() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textBottomAnchorConstraint = textView.bottomAnchor.constraint(equalTo: contentView.topAnchor,
                                                                      constant: 30)
        textView.backgroundColor = .subviewsBackgtound
        textView.layer.cornerRadius = 16
        textView.placeholder = NSLocalizedString("New", comment: "")
        textView.font = .body
        textView.textColor = .text
        textView.placeholderColor = .textGray
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                                          constant: -16)
        ])
    }
}
