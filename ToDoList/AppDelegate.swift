//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Софья Тимохина on 04.06.2021.
//

import UIKit

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
        let viewController = ToDoViewController(toDoService: toDoService)
        navigationController.pushViewController(viewController, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
