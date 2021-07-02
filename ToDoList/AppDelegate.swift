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
//        window = UIWindow()
//        let navigationController = UINavigationController()
//        let model = ToDoModel()
//        let viewController = ToDoViewController(model: model)
//        navigationController.pushViewController(viewController, animated: true)
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
        let networking = DefaultNetworkingService()
        let toDoItem = ToDoItem(id: "6",
                                text: "111",
                                importance: .basic,
                                deadline: nil, color: "",
                                done: false,
                                updatedAt: Int(Date().timeIntervalSince1970),
                                createdAt: Int(Date().timeIntervalSince1970),
                                isDirty: false)
        networking.postToDoItem(toDoItem, completion: { result in
            print(result)
        })
        return true
    }
}
