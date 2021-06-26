//
//  ToDoTableViewDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 26.06.2021.
//

import UIKit

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (doneShown ? model.toDoItemsCount() : model.notDoneToDoItemsCount()) + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastSectionIndex = doneShown ? model.toDoItemsCount() : model.notDoneToDoItemsCount()
        if indexPath.row == lastSectionIndex {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewToDoCell.self)") as? NewToDoCell else {
                return UITableViewCell() }
            cell.textView.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoCell.self)") as? ToDoCell else {
            return UITableViewCell() }
            let toDoItem = model.getToDoItem(at: indexPath.row, doneShown: doneShown)
            cell.loadData(toDoItem: toDoItem)
            return cell
        }
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
        showButton.setTitle(NSLocalizedString(doneShown ? "Hide" : "Show", comment: ""), for: .normal)
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
