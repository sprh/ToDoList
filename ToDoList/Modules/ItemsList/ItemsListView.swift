//
//  ItemsListView.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import UIKit

class ItemsListView: UIViewController {
    let presenter: ItemsListPresenter!

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = true
        tableView.delaysContentTouches = true
        tableView.canCancelContentTouches = true
        tableView.register(ToDoCell.self, forCellReuseIdentifier: "\(ToDoCell.self)")
        tableView.register(NewToDoCell.self, forCellReuseIdentifier: "\(NewToDoCell.self)")
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let addButton: UIButton = {
        let addButton = UIButton()
        addButton.setImage(.addButton, for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()

    var showButton: UIButton = {
        let showButton = UIButton()
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.setTitleColor(.azure, for: .normal)
        showButton.titleLabel?.font = .headkune
        return showButton
    }()

    var showLabel: UILabel = {
        let showLabel = UILabel()
        showLabel.translatesAutoresizingMaskIntoConstraints = false
        showLabel.textColor = .textGray
        showLabel.font = .headkune
        return showLabel
    }()

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
    }

    func setupView() {
        view = UIView()
        view.backgroundColor = .background
        navigationItem.title = "My to-dos".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.sizeToFit()
        hideKeyboardWhenTappedAround()
        keyboardWillShow(tableView)
        keyboardWillHide(tableView)
        addSubviews()
    }

    func addSubviews() {
        view.addSubview(addButton)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate(
            [tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.topAnchor.constraint(equalTo: view.topAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }

    func setShowLabelText() {
        showLabel.text = "\("Done".localized) — \(presenter.doneItemsCount)"
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

extension ItemsListView: ItemsListViewDelegate {
}

extension ItemsListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getItemsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastIndex {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewToDoCell.self)") as? NewToDoCell else {
                return UITableViewCell() }
            // TODO: add methods to add an item from the last cell.
//            cell.textView.delegate = self
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
        let view = UIView()
        setShowLabelText()
        view.addSubview(showLabel)
        NSLayoutConstraint.activate([
            showLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            showLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 18),
            showLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18)
        ])
        showButton.setTitle(presenter.doneShown ? "Hide".localized : "Show".localized, for: .normal)
        view.addSubview(showButton)
        NSLayoutConstraint.activate([
            showButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            showButton.centerYAnchor.constraint(equalTo: showLabel.centerYAnchor)
        ])
        showButton.addTarget(self, action: #selector(showButtonClick), for: .touchUpInside)
        return view
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // TODO: show another view.
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !(tableView.cellForRow(at: indexPath) is ToDoCell) { return nil}
        let trashAction =
            UIContextualAction(style: .normal, title: "",
            handler: {[weak self] (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else { success(false); return }
            print(cell)
// TODO: Delete it self.deleteToDoItem(id: cell.toDoItem.id, indexPath: indexPath)
            self?.tableViewDeleteOldCell(at: indexPath)
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
            cell.doneChanged()
// TODO:            self.updateToDoItemDone(id: cell.toDoItem.id, indexPath: indexPath)
            self?.setShowLabelText()
            success(true)
        })
        doneAction.image = .done
        doneAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [doneAction])
    }

    func tableViewAddNew() {
        self.tableView.performBatchUpdates({
            let itemsCount = tableView.numberOfRows(inSection: 0)
            let index = IndexPath(row: itemsCount - 1, section: 0)
            self.tableView.insertRows(at: [index], with: .fade)
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

extension ItemsListView {
    @objc func showButtonClick() {
        presenter.doneShownSettingWasChanged()
        tableView.reloadData()
    }
}


// How i recently did preview:
// func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) ->
//UIContextMenuConfiguration? {
//    self.indexPath = indexPath
//    if !(tableView.cellForRow(at: indexPath) is ToDoCell) {
//        self.indexPath = nil
//        return nil
//    }
//    let actionProvider: UIContextMenuActionProvider = { _ in
//        let copyAction = UIAction(title: "Copy".localized) { _ in
//                guard let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else { return }
//                let pasteboard = UIPasteboard.general
//                pasteboard.string = cell.getCopy()
//            }
//        return UIMenu(title: "", children: [copyAction])
//    }
//
//    return UIContextMenuConfiguration(identifier: "\(indexPath)" as NSCopying,
//                                      previewProvider: makePreview, actionProvider: actionProvider)
//}
//func makePreview() -> UIViewController {
//    guard let indexPath = indexPath,
//          let cell = tableView.cellForRow(at: indexPath) as? ToDoCell else {
//        return UIViewController()
//    }
//    let model = NewToDoModel(toDoItem: cell.toDoItem, toDoService: toDoService, indexPath: indexPath)
//    model.delegate = self
//    let destinationVc = NewToDoViewController(model: model)
//    return destinationVc
//}
//func tableView(_ tableView: UITableView,
//               willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
//               animator: UIContextMenuInteractionCommitAnimating) {
//    DispatchQueue.main.async {
//        let newToDoViewController = self.makePreview()
//        let newToDoNavigationController = UINavigationController(rootViewController: newToDoViewController)
//        self.present(newToDoNavigationController, animated: true, completion: nil)
//    }
//}
