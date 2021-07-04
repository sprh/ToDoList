//
//  ToDoTableViewDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 26.06.2021.
//

import UIKit

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemsCount() + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastSectionIndex = toDoItemsCount()
        if indexPath.row == lastSectionIndex {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewToDoCell.self)") as? NewToDoCell else {
                return UITableViewCell() }
            cell.textView.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoCell.self)") as? ToDoCell else {
            return UITableViewCell() }
            let toDoItem = getToDoItem(at: indexPath.row, doneShown: doneShown)
            cell.loadData(toDoItem: toDoItem)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell,
              let toDoItem = toDoService.getToDoItem(id: cell.toDoItem.id) else { return }
        let newToDoModel = NewToDoModel(toDoItem: toDoItem, toDoService: toDoService, indexPath: indexPath)
        newToDoModel.delegate = self
        let newToDoViewController = NewToDoViewController(model: newToDoModel)
        let newToDoNavigationController = UINavigationController(rootViewController: newToDoViewController)
        self.present(newToDoNavigationController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 { return UIView() }
        let view = UIView()
        showLabelSetText()
        showLabel.translatesAutoresizingMaskIntoConstraints = false
        showLabel.textColor = .textGray
        showLabel.font = .headkune
        view.addSubview(showLabel)
        NSLayoutConstraint.activate([
            showLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            showLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 18),
            showLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18)
        ])
        showButton.setTitle(doneShown ? "Hide".localized : "Show".localized, for: .normal)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.setTitleColor(.azure, for: .normal)
        showButton.titleLabel?.font = .headkune
        view.addSubview(showButton)
        NSLayoutConstraint.activate([
            showButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            showButton.centerYAnchor.constraint(equalTo: showLabel.centerYAnchor)
        ])
        showButton.addTarget(self, action: #selector(showButtonClick), for: .touchUpInside)
        return view
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                    indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !(tableView.cellForRow(at: indexPath) is ToDoCell) { return nil}
        let trashAction =
            UIContextualAction(style: .normal, title: "",
                handler: {(_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
                  guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else { success(false); return }
                    self.deleteToDoItem(id: cell.toDoItem.id, indexPath: indexPath)
                })
        trashAction.image = .trash
        trashAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [trashAction])
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {
        if !(tableView.cellForRow(at: indexPath) is ToDoCell) { return nil}
        let doneAction = UIContextualAction(style: .normal, title: "",
            handler: {(_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else { success(false); return }
            cell.doneChanged()
            self.updateToDoItemDone(id: cell.toDoItem.id, indexPath: indexPath)
            self.showLabelSetText()
            success(true)
        })
        doneAction.image = .done
        doneAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    func showLabelSetText() {
        showLabel.text = "\("Done".localized)" +
            "— \(getDoneItemsCount())"
    }
    func tableViewAddNew() {
        self.tableView.performBatchUpdates({
        self.tableView.insertRows(at: [IndexPath(row: toDoItemsCount() - 1, section: 0)],
                                  with: .fade)
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
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) ->
    UIContextMenuConfiguration? {
        self.indexPath = indexPath
        if !(tableView.cellForRow(at: indexPath) is ToDoCell) {
            self.indexPath = nil
            return nil
        }
        let actionProvider: UIContextMenuActionProvider = { _ in
            let copyAction = UIAction(title: "Copy".localized) { _ in
                    guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else { return }
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = cell.getCopy()
                }
            return UIMenu(title: "", children: [copyAction])
        }

        return UIContextMenuConfiguration(identifier: "\(indexPath)" as NSCopying,
                                          previewProvider: makePreview, actionProvider: actionProvider)
    }
    func makePreview() -> UIViewController {
        guard let indexPath = indexPath,
              let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else {
            return UIViewController()
        }
        let model = NewToDoModel(toDoItem: cell.toDoItem, toDoService: toDoService, indexPath: indexPath)
        model.delegate = self
        let destinationVc = NewToDoViewController(model: model)
        return destinationVc
    }
    func tableView(_ tableView: UITableView,
                   willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionCommitAnimating) {
        DispatchQueue.main.async {
            let newToDoViewController = self.makePreview()
            let newToDoNavigationController = UINavigationController(rootViewController: newToDoViewController)
            self.present(newToDoNavigationController, animated: true, completion: nil)
        }
    }
}
