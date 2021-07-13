//
//  ItemsListInterface.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import UIKit

class ItemsListInterface: UIView {
    let addButton = UIButton()
    let tableView = UITableView(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height),
                                              style: .insetGrouped)
    let showButton = UIButton()
    let showLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        addSubviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {
        addButton.setImage(.addButton, for: .normal)
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        [
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ].forEach({$0.isActive = true})
//        addButton.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
    }

    func addTableView() {
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.delaysContentTouches = true
        tableView.canCancelContentTouches = true
        tableView.register(ToDoCell.self, forCellReuseIdentifier: "\(ToDoCell.self)")
        tableView.register(NewToDoCell.self, forCellReuseIdentifier: "\(NewToDoCell.self)")
        tableView.backgroundColor = .clear
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}
