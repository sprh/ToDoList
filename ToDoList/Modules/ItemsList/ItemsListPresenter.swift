//
//  ItemsListPresenter.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.07.2021.
//

import Foundation
import Models

final class ItemsListPresenter {
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
    
    func loadDataFromDataBase() {
        viewDelegate?.startAnimatingActivityIndicator()
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
                    self.viewDelegate?.stopAnimatingActivityIndicator()
                    self.viewDelegate?.reloadItems()
                }
            case .failure:
                self.viewDelegate?.stopAnimatingActivityIndicator()
                return
            }
        }
        
    }
    
    func synchronize() {
        viewDelegate?.startAnimatingActivityIndicator()
        model.synchronize(model.allItems) { [weak self] _ in
            self?.viewDelegate?.stopAnimatingActivityIndicator()
            self?.viewDelegate?.reloadItems()
        }
    }
    
    func prepareNewItemView(_ item: ToDoItem, indexPath: IndexPath?) {
        let view = model.prepareNewItemView(item, indexPath: indexPath, itemsListDelegate: self)
        viewDelegate?.presentViewController(view)
    }
}

extension ItemsListPresenter: ItemsListPresenterDelegate {
    func updateItem(_ item: ToDoItem, at indexPath: IndexPath) {
        viewDelegate?.startAnimatingActivityIndicator()
        model.updateItem(item) { [weak self] in
            self?.viewDelegate?.stopAnimatingActivityIndicator()
        }
        if !model.doneShown, item.done {
            viewDelegate?.tableViewDeleteCell(at: indexPath)
        } else {
            viewDelegate?.tableViewReloadCell(at: indexPath)
        }
        if model.needToSynchronize {
            synchronize()
        }
    }
    
    func updateItemDone(_ item: ToDoItem, at indexPath: IndexPath) {
        updateItem(item.changeDone(), at: indexPath)
    }
    
    func deleteItem(_ id: String, at indexPath: IndexPath) {
        viewDelegate?.startAnimatingActivityIndicator()
        model.deleteItem(id) { [weak self] in
            self?.viewDelegate?.stopAnimatingActivityIndicator()
        }
        viewDelegate?.tableViewDeleteCell(at: indexPath)
        if model.needToSynchronize {
            synchronize()
        }
    }
    
    func addItem(_ item: ToDoItem) {
        viewDelegate?.startAnimatingActivityIndicator()
        model.addItem(item) { [weak self] in
            self?.viewDelegate?.stopAnimatingActivityIndicator()
        }
        viewDelegate?.tableViewAddCell()
        if model.needToSynchronize {
            synchronize()
        }
    }
}
