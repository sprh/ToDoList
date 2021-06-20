//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Софья Тимохина on 19.06.2021.
//

import UIKit

class ToDoCell: UICollectionViewCell {
    var toDoItem: ToDoItem?
    let text = UILabel()
    lazy var data = UILabel()
    let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .subviewsBackgtound
        setupSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setupSubviews() {
        text.font = .footnote
        text.textColor = .text
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 3
        contentView.addSubview(text)
        [
            text.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            text.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 38.95),
            text.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ].forEach({$0.isActive = true})
        doneButton.layer.cornerRadius = 20
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(doneButton)
        [
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32)
        ].forEach({$0.isActive = true})
    }
    public func loadData(toDoItem: ToDoItem) {
        self.toDoItem = toDoItem
        text.text = "Test"
    }
}
