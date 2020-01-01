//
//  UIView+MakeCircular.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-27.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

extension UIView {
    // Makes any view circular by making the corner radius equal to half the height
    func makeCircular() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}
