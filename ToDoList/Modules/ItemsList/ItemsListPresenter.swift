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
    
    func updateItem(_ item: ToDoItem) {
        model.updateItem(item)
    }
    
    func updateItemDone(_ item: ToDoItem) {
        updateItem(item.changeDone())
    }
    
    func deleteItem(_ id: String) {
        model.deleteItem(id)
    }
    
    func addItem(_ item: ToDoItem) {
        model.updateItem(item)
    }
    
    func loadDataFromDataBase() {
        model.loadFromDataBase { [weak self] result in
            switch result {
            case let .success(items):
                self?.model.allItems = items
                self?.viewDelegate?.reloadItems()
                self?.loadDataFromServer()
            case .failure:
                self?.loadDataFromServer()
            }
        }
    }
    
    func loadDataFromServer() {
        model.loadFromServer { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(items):
                self.model.merge(addedItems: self.model.allItems, oldItems: items, queue: .main) { result in
                    self.model.allItems = result
                    self.viewDelegate?.reloadItems()
                }
            case .failure:
                return
            }
        }
        
    }
}
