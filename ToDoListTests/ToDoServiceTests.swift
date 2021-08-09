//
//  ToDoServiceTests.swift
//  ToDoListTests
//
//  Created by Софья Тимохина on 28.07.2021.
//

@testable import ToDoList
@testable import Models
import XCTest

class ToDoServiceTests: XCTestCase {
    let mockNetworkingService = NetworkingServiceMock()
    let queue = DispatchQueue(label: "toDoServiceTests")
    
    func prepare() -> ToDoService {
        let toDoService = ToDoService(fileCacheService: FakeFileCacheService(), networkingService: mockNetworkingService)
        return toDoService
    }
    
    func testCreateNewItemCallsCreateMethod() {
        let service = prepare()
        let item = ToDoItem(text: "")
        service.create(item, queue: queue) {_ in }
        mockNetworkingService.verify(.create(.any, completion: .any), count: .once)
    }
    
    func testUpdateItemCallsUpdateMethod() {
        let service = prepare()
        let item = ToDoItem(text: "")
        service.create(item, queue: queue) {_ in }
        service.update(item, queue: queue) {_ in }
        mockNetworkingService.verify(.create(.any, completion: .any), count: .once)
    }
    
    func testDeleteItemCallsDeleteMethod() {
        let service = prepare()
        let item = ToDoItem(text: "")
        service.create(item, queue: queue) {_ in }
        service.delete(item.id, queue: queue) {_ in }
        mockNetworkingService.verify(.create(.any, completion: .any), count: .once)
    }
}
