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
        let aboutModel = AboutModel()
        let aboutViewController = AboutViewController(model: aboutModel)
        window?.rootViewController = aboutViewController
        window?.makeKeyAndVisible()
        window?.becomeFirstResponder()
        return true
    }
}
