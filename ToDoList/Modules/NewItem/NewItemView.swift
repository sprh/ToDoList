//
//  NewItemView.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import Foundation

final class NewItemView {
    let presenter: NewItemPresenter!
    
    init(presenter: NewItemPresenter) {
        self.presenter = presenter
    }
}

extension NewItemView: NewItemViewDelegate {
}
