//
//  ColorView.swift
//  ColorView
//
//  Created by Софья Тимохина on 11.07.2021.
//

import Foundation
import UIKit

public class ColorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let elementSize: CGFloat = 1.0
        let height = frame.height
        let width = frame.size.width
        for abscissa: CGFloat in stride(from: 0.0 ,to: width, by: elementSize) {
            let color = UIColor(hue: abscissa / width, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: abscissa, y: 0, width: elementSize, height: height))
        }
    }
}
