//
//  DefaultNetworkingService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import Foundation

class DefaultNetworkingService: NetworkingService {
    let queue = DispatchQueue(label: "com.ToDoList.NetworkQueue")
    let token = "Bearer Mjg5OTU2MDA0ODA2MDAxNDA2NA"
    var session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 30.0
        return session
    }()
    func getToDoItems(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        guard let url = URL(string: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net/tasks/") else {
            completion(.failure(NetworkError.incorrectUrl)); return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        let task = self.session.dataTask(with: urlRequest) {data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if response != nil, let data = data,
                    let toDoItemNetworkModels = try? JSONDecoder().decode([ToDoItemNetworkingModel].self, from: data) {
                let toDoItems = toDoItemNetworkModels.map({$0.toToDoItem()})
                completion(.success(toDoItems))
            } else if let response = response as? HTTPURLResponse {
                completion(.failure(self.findResponseError(response.statusCode)))
            } else {
                completion(.failure(NetworkError.unknownError))
            }
        }
        queue.async {
            task.resume()
        }
    }
    func postToDoItem(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        guard let url = URL(string: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net/tasks/") else {
            completion(.failure(NetworkError.incorrectUrl)); return
        }
        let networkingModel = ToDoItemNetworkingModel(toDoItem)
        guard let networkingModelData = networkingModel.toJsonData() else {
            completion(.failure(NetworkError.canNotSerializeItem)); return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        let array = [networkingModel.toJsonData()]
        let json = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
        urlRequest.httpBody = json
        urlRequest.httpMethod = "POST"
        let task = self.session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let toDoItemNetworkModel = try? JSONDecoder().decode(ToDoItemNetworkingModel.self, from: data) {
                completion(.success(toDoItemNetworkModel.toToDoItem()))
            } else if let response = response as? HTTPURLResponse {
                completion(.failure(self.findResponseError(response.statusCode)))
            } else {
                completion(.failure(NetworkError.unknownError))
            }
        }
        queue.async {
            task.resume()
        }
    }
    
    func putToDoItem(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        let networkingModel = ToDoItemNetworkingModel(toDoItem)
        guard let url = URL(string: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net/tasks/\(toDoItem.id)") else {
            completion(.failure(NetworkError.incorrectUrl)); return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
//        urlRequest.httpBody = networkingModel.toJsonData()
        urlRequest.httpMethod = "PUT"
        let task = self.session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let toDoItemNetworkModel = try? JSONDecoder().decode(ToDoItemNetworkingModel.self, from: data) {
                completion(.success(toDoItemNetworkModel.toToDoItem()))
            } else if let response = response as? HTTPURLResponse {
                completion(.failure(self.findResponseError(response.statusCode)))
            } else {
                completion(.failure(NetworkError.unknownError))
            }
        }
        queue.async {
            task.resume()
        }
    }
    
    func deleteToDoItem(id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        guard let url = URL(string: "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net/tasks/\(id)") else {
            completion(.failure(NetworkError.incorrectUrl)); return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "Delete"
        let task = self.session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let toDoItemNetworkModel = try? JSONDecoder().decode(ToDoItemNetworkingModel.self, from: data) {
                completion(.success(toDoItemNetworkModel.toToDoItem()))
            } else if let response = response as? HTTPURLResponse {
                completion(.failure(self.findResponseError(response.statusCode)))
            } else {
                completion(.failure(NetworkError.unknownError))
            }
        }
        queue.async {
            task.resume()
        }
    }
    
    func putToDoItems(addOrUpdateItems: [ToDoItem], deleteIds: [String], completion: @escaping (Result<ToDoItem, Error>) -> Void) {
//        let request =
//            [{
//            "deleted": deleteIds,
//            other: addOrUpdateItems
//            }]
    }
    func findResponseError(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 403:
            return .incorrectToken
        case 404:
            return .notFound
        default:
            return .serviceError(statusCode)
        }
    }
}

//
//let toDoItemNetworkModel = try? JSONDecoder().decode(ToDoItemNetworkingModel.self, from: data) {
// let toDoItem = toDoItemNetworkModel.toToDoItem()
