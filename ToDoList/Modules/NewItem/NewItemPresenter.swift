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
    
    init(model: NewItemModel) {
        self.model = model
    }
}
