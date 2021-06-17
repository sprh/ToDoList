//
//  FileCacheError.swift
//  ToDoList
//
//  Created by Софья Тимохина on 17.06.2021.
//

import UIKit

enum FileCacheError: Error {
    case fileNotFound
    case canNotWrite
    case canNotRead
}
