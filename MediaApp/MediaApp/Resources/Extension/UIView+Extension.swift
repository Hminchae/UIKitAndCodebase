//
//  UIView+Extension.swift
//  MediaApp
//
//  Created by 황민채 on 6/28/24.
//

import UIKit

extension UIView {
    func setGradient(color1: UIColor, color2: UIColor) {
        let gradientLayerName = "gradientLayer"
        
        if let oldLayer = (layer.sublayers?.first { $0.name == gradientLayerName }) as? CAGradientLayer {
            oldLayer.removeFromSuperlayer()
        }
        
        let gradient = CAGradientLayer()
        gradient.name = gradientLayerName
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
    
    func setDashedLineView() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [6, 3]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: self.bounds.midY),
                                CGPoint(x: self.bounds.width, y: self.bounds.midY)])
        shapeLayer.path = path
        shapeLayer.frame = self.bounds
        
        self.layer.addSublayer(shapeLayer)
    }
}
