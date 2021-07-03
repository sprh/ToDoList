//
//  FileCacheServiceProtocol.swift
//  ToDoList
//
//  Created by Софья Тимохина on 01.07.2021.
//

import UIKit

protocol FileCacheServiceProtocol {
    func saveFile(fileName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func loadFile(fileName: String, completion: @escaping (Result<[ToDoItem], Error>) -> Void)
}
