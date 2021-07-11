//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Софья Тимохина on 11.06.2021.
//

import UIKit
import Models

class ToDoViewController: UIViewController {
    let toDoService: ToDoService
    let addButton = UIButton()
    let tableView = UITableView(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height),
                                              style: .insetGrouped)
    var doneShown: Bool = false
    let showButton = UIButton()
    let showLabel = UILabel()
    var indexPath: IndexPath?
    var allItems: [ToDoItem] = []
    var items: [ToDoItem] {
        return !doneShown ? allItems.filter({!$0.done}) : allItems
    }
    public init(toDoService: ToDoService) {
        self.toDoService = toDoService
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addTableView()
        addAddButton()
        hideKeyboardWhenTappedAround()
        keyboardWillShow(tableView)
        keyboardWillHide(tableView)
        loadFromFile { [weak self] in
            self?.loadData { }
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.layoutIfNeeded()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.tableView.layoutIfNeeded()
    }
}
