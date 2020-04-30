//
//  UIButton+EnableDisable.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-27.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

extension UIButton {
    // Enables button and brings alpha up to 1.0
    func enable() {
        self.isEnabled = true
        self.fadeIn()
    }
    
    // Disabled button and lowers alpha to 0.7
    func disable() {
        self.isEnabled = false
        self.fade(toAlpha: 0.3)
    }
    
}
