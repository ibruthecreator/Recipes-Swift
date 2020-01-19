//
//  UIView+FadeInOut.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-27.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

extension UIView {
    // Fades in at any given speed and to any alpha
    func fadeIn(withDuration duration: TimeInterval = 0.2, withDelay delay: TimeInterval = 0.0) {
        UIView.animate(withDuration: duration, delay: delay, animations: {
            self.alpha = 1.0
        })
    }
    
    // Fades out at any given speed
    func fadeOut(withDuration duration: TimeInterval = 0.2, withDelay delay: TimeInterval = 0.0) {
        UIView.animate(withDuration: duration, delay: delay, animations: {
            self.alpha = 0.0
        })
    }
    
    // Fades to any alpha at any given speed
    func fade(toAlpha alpha: CGFloat, withDuration duration: TimeInterval = 0.2, withDelay delay: TimeInterval = 0.0) {
        UIView.animate(withDuration: duration) {
            self.alpha = alpha
        }
    }
}
