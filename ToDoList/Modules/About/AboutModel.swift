//
//  AboutModel.swift
//  ToDoList
//
//  Created by Софья Тимохина on 04.06.2021.
//

import Foundation

public class AboutModel {
    public func getTheCurrentVersionNumber() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as? String ?? "1.0"
        return version
    }
}
