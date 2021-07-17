//
//  NewItemViewDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 14.07.2021.
//

import Foundation

protocol NewItemViewDelegate: AnyObject {
    func loadData(_ data: (text: String, importance: Int, deadline: Int?, color: String?))
}
