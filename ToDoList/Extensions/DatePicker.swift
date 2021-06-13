//
//  DatePicker.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.06.2021.
//

import UIKit

extension UIDatePicker {
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: date)
        return selectedDate
    }
}
