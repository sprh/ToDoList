//
//  NewItemPresenter.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import Foundation

final class NewItemPresenter {
    let model: NewItemModel!
    weak var viewDelegate: NewItemViewDelegate?
    weak var itemsListDelegate: ItemsListPresenterDelegate?
    var standartColor: Bool {
        get { return model.standartColor }
        set { model.standartColor = newValue }
    }
    var datePickerShown: Bool {
        get { return model.datePickerShown }
        set { model.datePickerShown = newValue }
    }
    var itemIsNew: Bool {
        model.itemIsNew
    }
    
    init(model: NewItemModel) {
        self.model = model
    }
    
    func save(text: String, importance: Int, deadline: Int?, color: String?) {
        let newItem = model.updateItem(text: text, importanceIndex: importance, deadline: deadline, color: color)
        guard let indexPath = model.indexPath else {
            itemsListDelegate?.addItem(newItem)
            return
        }
        itemsListDelegate?.updateItem(newItem, at: indexPath)
    }
    
    func delete() {
        guard let id = model.toDoItem?.id,
              let indexPath = model.indexPath else { return }
        itemsListDelegate?.deleteItem(id, at: indexPath)
    }
    
    func getData() {
        guard let item = model.toDoItem else { return }
        let importance = model.importanceAsArray.firstIndex(of: item.importance.rawValue) ?? 1
        viewDelegate?.loadData((text: item.text, importance, deadline: item.deadline, color: item.color))
    }
    
    func dataWasChanged(text: String?, color: String?, deadline: Int?, importance: Int) {
        guard let text = text,
              !text.isEmpty else { viewDelegate?.updateVisibility(false); return }
        viewDelegate?.updateVisibility(model.areThereAnyDifferences(text: text,
                                                                    color: color,
                                                                    deadline: deadline,
                                                                    importanceIndex: importance))
    }
}
