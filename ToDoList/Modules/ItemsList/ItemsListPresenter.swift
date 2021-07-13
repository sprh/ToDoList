//
//  ItemsListPresenter.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import Foundation
import Models

class ItemsListPresenter {
    private let model: ItemsListModel!

    var doneShown: Bool {
        return model.doneShown
    }

    var doneItemsCount: Int {
        return model.doneItemsCount
    }

    weak var viewDelegate: ItemsListViewDelegate?

    public init(model: ItemsListModel!) {
        self.model = model
    }

    func getItem(at index: Int) -> ToDoItem {
        return model.getItem(at: index)
    }

    func getItemsCount() -> Int {
        return model.items.count
    }

    func doneShownSettingWasChanged() {
        model.doneShown.toggle()
    }
}
