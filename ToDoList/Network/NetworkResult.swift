//
//  NetworkResult.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case error(Error)
}
