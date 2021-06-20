//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Софья Тимохина on 19.06.2021.
//

import UIKit

class ToDoCell: UITableViewCell {
    lazy var toDoItem: ToDoItem = ToDoItem()
    let label = UILabel()
    lazy var data = UILabel()
    let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    let arrow = UIImageView(frame: CGRect(x: 0, y: 0, width: 6.95, height: 11.9))
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .subviewsBackgtound
        setupSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setupSubviews() {
        label.font = .headkune
        label.textColor = .text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        contentView.addSubview(label)
        [
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -38.95),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ].forEach({$0.isActive = true})
        doneButton.backgroundColor = .clear
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.clipsToBounds = true
        doneButton.addTarget(self, action: #selector(doneChanged), for: .touchUpInside)
        contentView.addSubview(doneButton)
        [
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ].forEach({$0.isActive = true})
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = .arrow
        contentView.addSubview(arrow)
        [
            arrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22.05),
            arrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ].forEach({$0.isActive = true})
    }
    public func loadData(toDoItem: ToDoItem) {
        self.toDoItem = toDoItem
        setDataToCell()
    }
    public func setDataToCell() {
        if toDoItem.done {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: toDoItem.text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range:
                                            NSRange(location: 0, length: attributeString.length))
            label.attributedText = attributeString
            doneButton.setImage(.doneCell, for: .normal)
        } else {
            switch toDoItem.importance {
            case .common, .unimportant:
                let attributeString: NSMutableAttributedString =
                    NSMutableAttributedString(string: toDoItem.text)
                label.attributedText = attributeString
                doneButton.setImage(.notDoneCell, for: .normal)
            case .important:
                let attributeString: NSMutableAttributedString =
                    NSMutableAttributedString(string: "!!\(toDoItem.text)")
                attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red,
                                             range: NSRange(location: 0, length: 2))
                label.attributedText = attributeString
                doneButton.setImage(.importantCell, for: .normal)
            }
        }
    }
}

extension ToDoCell {
    @objc func doneChanged() {
        toDoItem = ToDoItem(id: toDoItem.id, text: toDoItem.text, importance: toDoItem.importance, deadline: toDoItem.deadline, color: toDoItem.color, done: !toDoItem.done)
        setDataToCell()
    }
}
