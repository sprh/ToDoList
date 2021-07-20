//
//  ItemsListInterface.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import UIKit

final class ItemsListInterface: UIView {
    let tableView = UITableView()
    let addButton = UIButton()
    var spinner = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubviews() {
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = true
        tableView.delaysContentTouches = true
        tableView.canCancelContentTouches = true
        tableView.register(ToDoCell.self, forCellReuseIdentifier: "\(ToDoCell.self)")
        tableView.register(NewToDoCell.self, forCellReuseIdentifier: "\(NewToDoCell.self)")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        NSLayoutConstraint.activate(
            [tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
             tableView.topAnchor.constraint(equalTo: topAnchor),
             tableView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        addButton.setImage(.addButton, for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
