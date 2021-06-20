//
//  NavigationBar.swift
//  ToDoList
//
//  Created by Софья Тимохина on 20.06.2021.
//

import UIKit

extension UINavigationBar {
    public func largeTitleHeight() -> CGFloat {
        let maxSize = self.subviews
            .filter { $0.frame.origin.y > 0 }
            .max { $0.frame.origin.y < $1.frame.origin.y }
            .map { $0.frame.size }
        return maxSize?.height ?? 0
    }
}
