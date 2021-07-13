//
//  ItemsListPresenter.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import Foundation

class ItemsListPresenter {
    private let model: ItemsListModel!
    weak var viewDelegate: ItemsListViewDelegate?

    public init(model: ItemsListModel!) {
        self.model = model
    }
}
