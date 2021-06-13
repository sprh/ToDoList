//
//  ColorExtension.swift
//  ToDoList
//
//  Created by Софья Тимохина on 04.06.2021.
//

import UIKit

extension UIColor {
    static var background: UIColor = UIColor(named: "backgroundColor") ?? .white
    static var text: UIColor = UIColor(named: "textColor") ?? .black
    static var subviewsBackgtound: UIColor = UIColor(named: "subviewsBackgtoundColor") ?? .white
    static var textGray: UIColor = UIColor(named: "textGrayColor") ?? .gray
    static var segmented: UIColor = UIColor(named: "segmentedColor") ?? .gray
    static var segmentedSelected: UIColor = UIColor(named: "segmentedSelectedColor") ?? .gray
    static var azure: UIColor = UIColor(named: "azure") ?? .blue
    func hex() -> String {
        var colorRed: CGFloat = 0
        var colorGreen: CGFloat = 0
        var colorBlue: CGFloat = 0
        var alp: CGFloat = 0
        getRed(&colorRed, green: &colorGreen, blue: &colorBlue, alpha: &alp)
        let rgb: Int = (Int)(colorRed * 255) << 16 | (Int)(colorGreen * 255) << 8 | (Int)(colorBlue * 255) << 0
        return String(format: "#%06x", rgb)
    }
}
