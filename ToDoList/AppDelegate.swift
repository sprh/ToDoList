//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 04.06.2021.
//

import UIKit
import Models

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let navigationController = UINavigationController()
        let toDoService = createServices()
        let graph = ItemsListGraph(toDoService: toDoService)
        let viewController = graph.viewController
        navigationController.pushViewController(viewController, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    func createServices() -> ToDoServiceProtocol {
        if ProcessInfo.processInfo.arguments.contains("testing") {
            let service = FakeToDoService()
            return service
        } else {
            let graph = ToDoServiceGraph()
            return graph.toDoService
        }
    }
}
