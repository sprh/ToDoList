//
//  DefaultNetworkingService.swift
//  ToDoList
//
//  Created by Софья Тимохина on 27.06.2021.
//

import Foundation
import Models

final class DefaultNetworkingService: NetworkingService {
    let queue = DispatchQueue(label: "NetworkQueue", attributes: [.concurrent])
    let path: String = "https://d5dps3h13rv6902lp5c8.apigw.yandexcloud.net/tasks/"
    var session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 30.0
        return session
    }()
    
    func createURL(path: String) -> URLRequest? {
        guard let url = URL(string: path) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer Mjg5OTU2MDA0ODA2MDAxNDA2NA", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    
    func getAll(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        guard var urlRequest = createURL(path: path) else {
            completion(.failure(NetworkError.incorrectUrl)); return
        }
        urlRequest.httpMethod = "GET"
        let task = createTask(completion: completion, urlRequest: urlRequest)
        queue.async {
            task.resume()
        }
    }
    
    func create(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        guard var urlRequest = createURL(path: path) else { completion(.failure(NetworkError.incorrectUrl)); return }
        let networkingModel = ToDoItemNetworkingModel(toDoItem)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(networkingModel)
        let task = createTask(completion: completion, urlRequest: urlRequest)
        queue.async {
            task.resume()
        }
    }
    
    func update(_ toDoItem: ToDoItem, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        guard var urlRequest = createURL(path: "\(path)\(toDoItem.id)") else {
            completion(.failure(NetworkError.incorrectUrl)); return }
        let networkingModel = ToDoItemNetworkingModel(toDoItem)
        urlRequest.httpBody = try? JSONEncoder().encode(networkingModel)
        urlRequest.httpMethod = "PUT"
        let task = createTask(completion: completion, urlRequest: urlRequest)
        queue.async {
            task.resume()
        }
    }
    
    func delete(_ id: String, completion: @escaping (Result<ToDoItem, Error>) -> Void) {
        guard var urlRequest = createURL(path: "\(path)\(id)") else {
            completion(.failure(NetworkError.incorrectUrl)); return }
        urlRequest.httpMethod = "DELETE"
        let task = createTask(completion: completion, urlRequest: urlRequest)
        queue.async {
            task.resume()
        }
    }
    
    func putAll(addOrUpdateItems: [ToDoItem], deleteIds: [String],
                completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        guard var urlRequest = createURL(path: path) else {
            completion(.failure(NetworkError.incorrectUrl)); return }
        urlRequest.httpMethod = "PUT"
        let toDoModels = addOrUpdateItems.map({ToDoItemNetworkingModel($0).json})
        let request: [String: Any] = ["deleted": deleteIds,
                                      "other": toDoModels]
        let data = try? JSONSerialization.data(withJSONObject: request, options: [])
        urlRequest.httpBody = data
        let task = createTask(completion: completion, urlRequest: urlRequest)
        queue.async {
            task.resume()
        }
    }
    
    func createTask(completion: @escaping (Result<[ToDoItem], Error>) -> Void,
                    urlRequest: URLRequest) -> URLSessionDataTask {
        let task = self.session.dataTask(with: urlRequest) {data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if response != nil, let data = data,
                    let toDoItemNetworkModels = try? JSONDecoder().decode([ToDoItemNetworkingModel].self, from: data) {
                let toDoItems = toDoItemNetworkModels.map({ToDoItem($0)})
                completion(.success(toDoItems))
            } else if let response = response as? HTTPURLResponse {
                completion(.failure(self.findResponseError(response.statusCode)))
            } else {
                completion(.failure(NetworkError.unknownError))
            }
        }
        return task
    }
    
    func createTask(completion: @escaping (Result<ToDoItem, Error>) -> Void,
                    urlRequest: URLRequest) -> URLSessionDataTask {
        let task = self.session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data,
                      let toDoItemNetworkModel = try? JSONDecoder().decode(ToDoItemNetworkingModel.self, from: data) {
                completion(.success(ToDoItem(toDoItemNetworkModel)))
            } else if let response = response as? HTTPURLResponse {
                completion(.failure(self.findResponseError(response.statusCode)))
            } else {
                completion(.failure(NetworkError.unknownError))
            }
        }
        return task
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
