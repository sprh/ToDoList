//
//  ItemsListGraph.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import Foundation

final class ItemsListGraph {
    let view: ItemsListView
    let presenter: ItemsListPresenter
    let model: ItemsListModel

    public init() {
        model = ItemsListModel()
        presenter = ItemsListPresenter(model: model)
        view = ItemsListView(presenter: presenter)
        presenter.viewDelegate = view
    }
}
