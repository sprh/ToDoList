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
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentSize.height -= addButton.bounds.height
    }
    private func setupView() {
        view = UIView()
        view.backgroundColor = .background
        navigationItem.title = NSLocalizedString("My to-dos", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
    }
    private func addAddButton() {
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
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.delaysContentTouches = true
        tableView.canCancelContentTouches = true
        tableView.register(ToDoCell.self, forCellReuseIdentifier: "\(ToDoCell.self)")
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
    }
}

extension ToDoViewController {
    @objc func addButtonClick() {
        let newToDoModel = NewToDoModel(toDoItem: ToDoItem(text: "", color: "#ACFA00", done: false), fileCache:
                                            model.fileCache, indexPath: nil)
        let newToDoViewController = NewToDoViewController(model: newToDoModel)
        let newToDoNavigationController = UINavigationController(rootViewController: newToDoViewController)
        self.present(newToDoNavigationController, animated: true, completion: nil)
    }
    @objc func showButtonClick() {
        doneShown = !doneShown
        showButton.setTitle(NSLocalizedString(doneShown ? "Hide" : "Show", comment: ""), for: .normal)
        tableView.reloadData()
    }
    @objc func doneButtonClick(sender: DoneButton) {
        guard let id = sender.toDoItemId else { return }
        model.updateToDoItemDone(id: id)
        tableView.reloadData()
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneShown ? model.toDoItemsCount() : model.notDoneToDoItemsCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoCell.self)") as? ToDoCell else {
            return UITableViewCell()
        }
        let toDoItem = model.getToDoItem(at: indexPath.row, doneShown: doneShown)
        cell.loadData(toDoItem: toDoItem)
        cell.doneButton.addTarget(self, action: #selector(doneButtonClick(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else { return }
        let newToDoModel = NewToDoModel(toDoItem: cell.toDoItem, fileCache: model.fileCache, indexPath: indexPath)
        newToDoModel.delegate = self
        let newToDoViewController = NewToDoViewController(model: newToDoModel)
        let newToDoNavigationController = UINavigationController(rootViewController: newToDoViewController)
        self.present(newToDoNavigationController, animated: true, completion: {() in
        })
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 { return UIView() }
        let view = UIView()
        showLabelSetText()
        showLabel.translatesAutoresizingMaskIntoConstraints = false
        showLabel.textColor = .textGray
        showLabel.font = .headkune
        view.addSubview(showLabel)
        [
            showLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            showLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 18),
            showLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18)
        ].forEach({$0.isActive = true})
        showButton.setTitle(NSLocalizedString("Show", comment: ""), for: .normal)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.setTitleColor(.azure, for: .normal)
        showButton.titleLabel?.font = .headkune
        view.addSubview(showButton)
        [
            showButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            showButton.centerYAnchor.constraint(equalTo: showLabel.centerYAnchor)
        ].forEach({$0.isActive = true})
        showButton.addTarget(self, action: #selector(showButtonClick), for: .touchUpInside)
        return view
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                    indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trashAction =
            UIContextualAction(style: .normal, title: "",
                handler: {(_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
                  guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else { success(false); return }
                  self.model.deleteToDoItem(id: cell.toDoItem.id)
                  self.showLabelSetText()
                  self.tableViewDeleteOldCell(at: indexPath)
                })
        trashAction.image = .trash
        trashAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [trashAction])
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: "",
            handler: {(_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else { success(false); return }
            cell.doneChanged()
            self.model.updateToDoItemDone(id: cell.toDoItem.id)
            self.showLabelSetText()
            success(true)
        })
        doneAction.image = .done
        doneAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    func showLabelSetText() {
        showLabel.text = "\(NSLocalizedString("Done", comment: ""))" +
            "— \(model.toDoItemsCount() - model.notDoneToDoItemsCount())"
    }
    func tableViewAddNew() {
        self.tableView.performBatchUpdates({
        self.tableView.insertRows(at:
                                    [IndexPath(row: self.doneShown ? self.model.toDoItemsCount() - 1 :
                                                self.model.notDoneToDoItemsCount() - 1, section: 0)], with: .fade)
        }, completion: nil)
    }
    func tableViewReloadOldCell(at indexPath: IndexPath) {
        tableView.performBatchUpdates({
              tableView.reloadRows(at: [indexPath], with: .fade)
        }, completion: nil)
    }
    func tableViewDeleteOldCell(at indexPath: IndexPath) {
        tableView.performBatchUpdates({
              tableView.deleteRows(at: [indexPath], with: .fade)
        }, completion: nil)
    }
}

extension ToDoViewController: NewToDoDelegate {
    func delete(indexPath: IndexPath) {
        tableViewDeleteOldCell(at: indexPath)
    }
    func add() {
        tableViewAddNew()
    }
    func update(indexPath: IndexPath) {
        tableViewReloadOldCell(at: indexPath)
    }
}
