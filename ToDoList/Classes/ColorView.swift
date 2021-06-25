//
//  UIColorView.swift
//  ToDoList
//
//  Created by Софья Тимохина on 13.06.2021.
//

import UIKit

class ColorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
   }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        backgroundColor = colorWithGradient(frame: rect, colors: [.text, .purple, .blue,
                          .green, .yellow, .orange, .red])
    }
    func colorWithGradient(frame: CGRect, colors: [UIColor]) -> UIColor {
        let context = UIGraphicsGetCurrentContext()
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.05, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = frame
        let cgColors = colors.map({$0.cgColor})
        gradientLayer.colors = cgColors
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: context!)
        guard let colorImage = UIGraphicsGetImageFromCurrentImageContext() else { return .text }
        UIGraphicsEndImageContext()
        return UIColor(patternImage: colorImage)
    }
    func getColor(from point: CGPoint) -> UIColor {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8,
                                bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context)
        let color = UIColor(red: CGFloat(pixel[0]) / 255.0,
                            green: CGFloat(pixel[1]) / 255.0,
                            blue: CGFloat(pixel[2]) / 255.0,
                            alpha: 1)

        pixel.deallocate()
        return color
    }
}
