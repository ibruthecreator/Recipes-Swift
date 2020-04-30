//
//  UIView+RoundCorners.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-09.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
    
        layer.mask = mask
    }
}
