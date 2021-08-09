//
//  ToDoServiceGraph.swift
//  ToDoList
//
//  Created by Софья Тимохина on 22.07.2021.
//

final class ToDoServiceGraph {
    private let fileCacheService: FileCacheServiceProtocol
    private let networkingService: NetworkingService
    private let service: ToDoServiceProtocol
    public var toDoService: ToDoServiceProtocol { service }
    
    public init() {
        fileCacheService = FileCacheService(fileCache: FileCache())
        networkingService = DefaultNetworkingService()
        service = ToDoService(fileCacheService: fileCacheService, networkingService: networkingService)
    }
}
