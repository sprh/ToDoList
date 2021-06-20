//
//  ImageExtension.swift
//  ToDoList
//
//  Created by Софья Тимохина on 04.06.2021.
//

import UIKit

extension UIImage {
    static var logo: UIImage = UIImage(named: "logo") ?? UIImage()
    static var addButton: UIImage = UIImage(named: "addButton") ?? UIImage()
    static var lowImportance: UIImage = UIImage(named: "lowImportance") ?? UIImage()
    static var highImportance: UIImage = UIImage(named: "highImportance") ?? UIImage()
    static let doneCell: UIImage = UIImage(named: "doneCell") ?? UIImage()
    static let notDoneCell: UIImage = UIImage(named: "notDoneCell") ?? UIImage()
    static let importantCell: UIImage = UIImage(named: "importantCell") ?? UIImage()
}
