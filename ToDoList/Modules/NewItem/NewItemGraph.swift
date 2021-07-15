//
//  NewItemGraph.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import Foundation
import Models

final class NewItemGraph {
    let presenter: NewItemPresenter
    let view: NewItemView
    let model: NewItemModel
    
    init(_ toDoItem: ToDoItem, indexPath: IndexPath?, itemsListDelegate: ItemsListPresenterDelegate?) {
        model = NewItemModel(toDoItem, indexPath: indexPath)
        presenter = NewItemPresenter(model: model)
        view = NewItemView(presenter: presenter)
        presenter.viewDelegate = view
        presenter.itemsListDelegate = itemsListDelegate
    }
}
