//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Софья Тимохина on 19.06.2021.
//

import UIKit
import Models

/// ToDoCell is a cell that contains information about a ToDoItem that already exists.
final class ToDoCell: UITableViewCell {
    lazy var toDoItem: ToDoItem = ToDoItem()
    let labelText: UILabel = {
        let label = UILabel()
        label.font = .headkune
        label.textColor = .text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    let dateText: UILabel = {
        let label = UILabel()
        label.font = .subhead
        label.textColor = .textGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    let dateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .calendar
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let arrow: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 7, height: 12))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .arrow
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .subviewsBackground
        selectionStyle = .none
        layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupSubviews() {
        contentView.subviews.forEach({$0.removeFromSuperview()})
        let hasDeadline = toDoItem.deadline != nil
        contentView.addSubview(labelText)
        NSLayoutConstraint.activate([
            labelText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            labelText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            labelText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: hasDeadline ? 12 : 16),
            labelText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: hasDeadline ? -32: -16)
        ])
        contentView.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        contentView.addSubview(arrow)
        NSLayoutConstraint.activate([
            arrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            arrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        guard let deadline = toDoItem.deadline else { return }
        addDateLabels(deadline: deadline)
    }
    
    private func addDateLabels(deadline: Int) {
        let date = Date.init(timeIntervalSince1970: Double(deadline))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateText.text = dateFormatter.string(from: date)
        contentView.addSubview(dateImageView)
        contentView.addSubview(dateText)
        NSLayoutConstraint.activate([
            dateImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 54),
            dateImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            dateText.leadingAnchor.constraint(equalTo: dateImageView.trailingAnchor, constant: 4),
            dateText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    public func loadData(toDoItem: ToDoItem) {
        self.toDoItem = toDoItem
        setDataToCell()
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
            case .low, .basic:
                let attributeString: NSMutableAttributedString =
                    NSMutableAttributedString(string: toDoItem.text)
                labelText.attributedText = attributeString
                doneButton.setImage(.notDoneCell, for: .normal)
            case .important:
                let attributeString: NSMutableAttributedString =
                    NSMutableAttributedString(string: "!!\(toDoItem.text)")
                // TODO why it doesn't work(
                attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red,
                                             range: NSRange(location: 0, length: 2))
                labelText.attributedText = attributeString
                doneButton.setImage(.importantCell, for: .normal)
            }
        }
    }
    
    public func getCopy() -> String {
        var text = "\(toDoItem.done ? "[Finished]".localized : ";")\(toDoItem.text)\n"
        if toDoItem.deadline != nil {
            text += "\("Deadline".localized) \(dateText.text ?? "")"
        }
        return text
    }
}

extension ToDoCell {
    @objc func doneChanged() {
        toDoItem = toDoItem.changeDone()
        setDataToCell()
    }
}
