//
//  DefaultNetworkingService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import Foundation

class DefaultNetworkingService: NetworkingService {
    let queue = DispatchQueue(label: "com.ToDoList.NetworkQueue")
    var session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 30.0
        return session
    }()
    func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        guard let url = URL(string: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net/tasks") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer_Mjg5OTU2MDA0ODA2MDAxNDA2NA", forHTTPHeaderField: "Authorization")
        let task = self.session.dataTask(with: urlRequest)  { data, response, error in
            if let error = error {
            }
            if let response = response, let data = data {
            }
        }
        queue.async {
            task.resume()
        }
    }
    
    func postToDoItem(toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
    
    func putToDoItem(toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
    
    func deleteToDoItem(id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
    
    func putToDoItems(addOrUpdateItems: [ToDoItem], deleteIds: [String], completion: @escaping (Result<ToDoItem, Error>) -> Void) {
    }
}
