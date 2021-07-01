//
//  ToDoNewToDoDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 26.06.2021.
//

import UIKit

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
