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
        let fileCache = FileCacheService()
        let networkingService = DefaultNetworkingService()
        let toDoService = ToDoService(fileCacheService: fileCache, networkingService: networkingService)
        let graph = ItemsListGraph(toDoService: toDoService)
        let viewController = graph.view
        navigationController.pushViewController(viewController, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
