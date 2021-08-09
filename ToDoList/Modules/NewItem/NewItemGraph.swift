//
//  NewItemGraph.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import UIKit
import Models

final class NewItemGraph {
    private let presenter: NewItemPresenter
    private let view: NewItemView
    private let model: NewItemModel
    
    var viewController: NewItemView {
        return view
    }
    
    init(_ toDoItem: ToDoItem, indexPath: IndexPath?, itemsListDelegate: ItemsListPresenterDelegate?) {
        model = NewItemModel(toDoItem, indexPath: indexPath)
        presenter = NewItemPresenter(model: model)
        view = NewItemView(presenter: presenter)
        presenter.viewDelegate = view
        presenter.itemsListDelegate = itemsListDelegate
    }
}
