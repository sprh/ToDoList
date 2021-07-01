//
//  String.swift
//  ToDoList
//
//  Created by Софья Тимохина on 01.07.2021.
//

import Foundation

extension String {
    public var localized: String {
         NSLocalizedString(self, comment: "")
    }
}
