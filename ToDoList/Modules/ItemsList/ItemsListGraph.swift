//
//  ItemsListGraph.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import UIKit

final class ItemsListGraph {
    private let view: ItemsListView
    private let presenter: ItemsListPresenter
    private let model: ItemsListModel
    
    var viewController: ItemsListView {
        return view
    }

    public init(toDoService: ToDoServiceProtocol) {
        model = ItemsListModel(toDoService: toDoService)
        presenter = ItemsListPresenter(model: model)
        view = ItemsListView(presenter: presenter)
        presenter.viewDelegate = view
    }
}
