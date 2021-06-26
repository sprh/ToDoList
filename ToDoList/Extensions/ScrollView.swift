//
//  ScrollView.swift
//  ToDoList
//
//  Created by Софья Тимохина on 26.06.2021.
//

import UIKit

extension UIScrollView {
    func fitSizeOfContent() {
        let sumHeight = self.subviews.map({$0.frame.size.height}).reduce(0, {abscissa, ordinata in abscissa + ordinata})
        self.contentSize = CGSize(width: self.frame.width, height: sumHeight)
    }
}
