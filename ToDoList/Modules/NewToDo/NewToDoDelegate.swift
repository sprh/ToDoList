//
//  NewToDoDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 25.06.2021.
//

import Foundation

protocol NewToDoDelegate: AnyObject {
    func delete(indexPath: IndexPath)
    func update(indexPath: IndexPath)
    func add()
}
