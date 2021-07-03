//
//  NetworkError.swift
//  ToDoList
//
//  Created by Софья Тимохина on 02.07.2021.
//

import Foundation

enum NetworkError: Error {
    case incorrectUrl
    case incorrectToken
    case canNotSerializeItem
    case unknownError
    case serviceError(_ statusCode: Int)
    case notFound
}
