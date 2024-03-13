//
//  GradientView.swift
//  WrkplanPayroll
//
//  Created by Debashis Pal on 13/03/24.
//

import Foundation
import UIKit


@IBDesignable
class GradientBackgroundView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor(hexFromString: "#084F95")
    @IBInspectable var endColor: UIColor = UIColor(hexFromString: "#64B5F6")
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set up gradient layer
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }
}
