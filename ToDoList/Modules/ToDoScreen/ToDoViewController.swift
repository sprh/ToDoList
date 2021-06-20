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
    let tableView = UITableView(frame: .zero, style: .grouped)
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
        addSubviews()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = CGRect(x: 16, y: 0, width: view.bounds.width - 32,
                                 height: view.bounds.height)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NSLocalizedString("My to-dos", comment: "")
    }
    private func setupView() {
        view = UIView()
        view.backgroundColor = .background
    }
    private func addSubviews() {
        addButton.setImage(.addButton, for: .normal)
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        [
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ].forEach({$0.isActive = true})
        addButton.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
    }
    private func addTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoCell.self, forCellReuseIdentifier: "\(ToDoCell.self)")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .clear
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }
}

extension ToDoViewController {
    @objc func addButtonClick() {
        let newToDoModel = NewToDoModel(toDoItem: ToDoItem(text: "", color: "#ACFA00", done: false))
        let newToDoViewController = NewToDoViewController(model: newToDoModel)
        let newToDoNavigationController = UINavigationController(rootViewController: newToDoViewController)
        self.present(newToDoNavigationController, animated: true, completion: nil)
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.toDoItemsCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoCell.self)") as? ToDoCell else {
            return UITableViewCell()
        }
        let toDoItem = model.getToDoItem(at: indexPath.row)
        cell.loadData(toDoItem: toDoItem)
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.layoutIfNeeded()
    }
}
