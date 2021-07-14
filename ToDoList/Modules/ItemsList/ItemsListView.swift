//
//  ItemsListView.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import UIKit
import Models

final class ItemsListView: UIViewController {
    let presenter: ItemsListPresenter!
    func view() -> ItemsListInterface? {
        view as? ItemsListInterface
    }
    var tableView: UITableView {
        view()?.tableView ?? UITableView()
    }
    let tableViewHeaderView = ItemsListTableViewHeader()

    public init(presenter: ItemsListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
        presenter.loadDataFromDataBase()
    }

    func setupView() {
        view = ItemsListInterface()
        navigationItem.title = "My to-dos".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
        hideKeyboardWhenTappedAround()
        keyboardWillShow(tableView)
        keyboardWillHide(tableView)
    }

    func setShowLabelText() {
        tableViewHeaderView.showLabel.text = "\("Done".localized) — \(presenter.doneItemsCount)"
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

extension ItemsListView: ItemsListViewCellDelegate {
    func addItem(_ item: ToDoItem) {
        presenter.addItem(item)
    }
    
    func updateItem(_ item: ToDoItem, indexPath: IndexPath) {
        presenter.updateItemDone(item, at: indexPath)
    }
    
    func deleteItem(_ id: String, indexPath: IndexPath) {
        presenter.deleteItem(id, at: indexPath)
    }
}

extension ItemsListView: ItemsListViewDelegate {
    func reloadItems() {
        if isViewLoaded {
            tableView.reloadData()
        }
    }
    
    func tableViewAddCell() {
        self.tableView.performBatchUpdates({
            let itemsCount = tableView.numberOfRows(inSection: 0)
            let index = IndexPath(row: itemsCount - 1, section: 0)
            self.tableView.insertRows(at: [index], with: .fade)
        }, completion: nil)
    }

    func tableViewReloadCell(at indexPath: IndexPath) {
        tableView.performBatchUpdates({
            tableView.reloadRows(at: [indexPath], with: .fade)
            setShowLabelText()
        }, completion: nil)
    }

    func tableViewDeleteCell(at indexPath: IndexPath) {
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .fade)
            setShowLabelText()
        }, completion: nil)
    }
    
}

extension ItemsListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getItemsCount() + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastIndex {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewToDoCell.self)") as? NewToDoCell else {
                return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoCell.self)") as? ToDoCell else {
            return UITableViewCell() }
            let toDoItem = presenter.getItem(at: indexPath.row)
            cell.loadData(toDoItem: toDoItem)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 { return UIView() }
        setShowLabelText()
        tableViewHeaderView.showButton.addTarget(self, action: #selector(showButtonClick), for: .touchUpInside)
        return view
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // TODO: show another view.
        // Maybe here set a delegate
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !(tableView.cellForRow(at: indexPath) is ToDoCell) { return nil}
        let trashAction =
            UIContextualAction(style: .normal, title: "",
            handler: {[weak self] (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else { success(false); return }
            self?.deleteItem(cell.toDoItem.id, indexPath: indexPath)
        })
        trashAction.image = .trash
        trashAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [trashAction])
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !(tableView.cellForRow(at: indexPath) is ToDoCell) { return nil}
        let doneAction = UIContextualAction(style: .normal, title: "",
            handler: {[weak self] (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else { success(false); return }
            self?.updateItem(cell.toDoItem.changeDone(), indexPath: indexPath)
            success(true)
        })
        doneAction.image = .done
        doneAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
}

extension ItemsListView {
    @objc func showButtonClick(sender: UIButton) {
        presenter.doneShownSettingWasChanged()
        sender.setTitle(presenter.doneShown ? "Hide".localized : "Show".localized, for: .normal)
        tableView.reloadData()
    }
}
