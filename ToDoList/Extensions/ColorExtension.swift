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
    static var subviewsBackground: UIColor = UIColor(named: "subviewsBackgroundColor") ?? .white
    static var textGray: UIColor = UIColor(named: "textGrayColor") ?? .gray
    static var segmented: UIColor = UIColor(named: "segmentedColor") ?? .gray
    static var segmentedSelected: UIColor = UIColor(named: "segmentedSelectedColor") ?? .gray
    static var azure: UIColor = UIColor(named: "azure") ?? .blue
    static var green: UIColor = #colorLiteral(red: 0.2052684426, green: 0.7807833552, blue: 0.3487253785, alpha: 1)
    
    static func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let redColor: CGFloat = components?[0] ?? 0.0
        let greenColor: CGFloat = components?[1] ?? 0.0
        let blueColor: CGFloat = components?[2] ?? 0.0
        let hexString = String.init(format: "#%02lX%02lX%02lX",
        lroundf(Float(redColor * 255)), lroundf(Float(greenColor * 255)), lroundf(Float(blueColor * 255)))
        return hexString
     }

    static func colorWithHexString(hexString: String) -> UIColor {
        if !hexString.starts(with: "#") || hexString.count != 7 {
            return UIColor.text
        }
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
        let red: CGFloat = colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = colorComponentFrom(colorString: colorString, start: 4, length: 2)
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }

    static func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {
        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt64 = 0
        guard Scanner(string: String(fullHexString)).scanHexInt64(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        return floatValue
    }
}
