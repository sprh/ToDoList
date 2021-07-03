//
//  ToDoObjcMethods.swift
//  ToDoList
//
//  Created by Софья Тимохина on 26.06.2021.
//

import UIKit

extension ToDoViewController {
    @objc func addButtonClick() {
        let newToDoModel = NewToDoModel(toDoItem: ToDoItem(), toDoService: model.toDoService, indexPath: nil)
        newToDoModel.delegate = self
        let newToDoViewController = NewToDoViewController(model: newToDoModel)
        let newToDoNavigationController = UINavigationController(rootViewController: newToDoViewController)
        self.present(newToDoNavigationController, animated: true, completion: nil)
    }
    @objc func showButtonClick() {
        doneShown = !doneShown
        tableView.reloadData()
    }
    @objc func doneButtonClick(indexPath: IndexPath) {
        tableViewReloadOldCell(at: indexPath)
    }
}
