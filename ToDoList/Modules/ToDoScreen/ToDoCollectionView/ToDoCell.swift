//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Софья Тимохина on 19.06.2021.
//

import UIKit

/// ToDoCell is a cell that contains information about a ToDoItem that already exists.
class ToDoCell: UITableViewCell {
    lazy var toDoItem: ToDoItem = ToDoItem()
    let labelText = UILabel()
    var dateText = UILabel()
    let doneButton = DoneButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    var dateImageView = UIImageView()
    let arrow = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 12))
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .subviewsBackgtound
        selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setupSubviews() {
        contentView.subviews.forEach({$0.removeFromSuperview()})
        let hasDeadline = toDoItem.deadline != nil
        labelText.font = .headkune
        labelText.textColor = .text
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.numberOfLines = 3
        contentView.addSubview(labelText)
        [
            labelText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            labelText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            labelText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: hasDeadline ? 12 : 16),
            labelText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: hasDeadline ? -32: -16)
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
            arrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            arrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ].forEach({$0.isActive = true})
        guard let deadline = toDoItem.deadline else { return }
        addDateLabels(date: deadline)
    }
    private func addDateLabels(date: Date) {
        dateImageView.image = .calendar
        dateImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateImageView)
        [
            dateImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 54),
            dateImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ].forEach({$0.isActive = true})
        dateText.font = .subhead
        dateText.textColor = .textGray
        dateText.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateText)
        [
            dateText.leadingAnchor.constraint(equalTo: dateImageView.trailingAnchor, constant: 4),
            dateText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ].forEach({$0.isActive = true})
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateText.text = dateFormatter.string(from: date)
    }
    public func loadData(toDoItem: ToDoItem) {
        self.toDoItem = toDoItem
        setDataToCell()
        doneButton.toDoItemId = toDoItem.id
        setupSubviews()
    }
    public func setDataToCell() {
        if toDoItem.done {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: toDoItem.text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range:
                                            NSRange(location: 0, length: attributeString.length))
            labelText.attributedText = attributeString
            doneButton.setImage(.doneCell, for: .normal)
        } else {
            switch toDoItem.importance {
            case .common, .unimportant:
                let attributeString: NSMutableAttributedString =
                    NSMutableAttributedString(string: toDoItem.text)
                labelText.attributedText = attributeString
                doneButton.setImage(.notDoneCell, for: .normal)
            case .important:
                let attributeString: NSMutableAttributedString =
                    NSMutableAttributedString(string: "!!\(toDoItem.text)")
                attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red,
                                             range: NSRange(location: 0, length: 2))
                labelText.attributedText = attributeString
                doneButton.setImage(.importantCell, for: .normal)
            }
        }
    }
}

extension ToDoCell {
    @objc func doneChanged() {
        toDoItem = ToDoItem(id: toDoItem.id,
                            text: toDoItem.text,
                            importance: toDoItem.importance,
                            deadline: toDoItem.deadline,
                            color: toDoItem.color,
                            done: !toDoItem.done)
        setDataToCell()
    }
}
