//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Софья Тимохина on 11.06.2021.
//

import Foundation
import UIKit

class ToDoViewController: UIViewController {
    let model: ToDoModel!
    let addButton = UIButton()
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:
                                                UIScreen.main.bounds.height), style: .insetGrouped)
    var doneShown: Bool = false
    let showButton = UIButton()
    let showLabel = UILabel()
    var indexPath: IndexPath?
    public init(model: ToDoModel) {
        self.model = model
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
        loadData()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.layoutIfNeeded()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.tableView.layoutIfNeeded()
    }
    func loadData() {
        model.loadData { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
