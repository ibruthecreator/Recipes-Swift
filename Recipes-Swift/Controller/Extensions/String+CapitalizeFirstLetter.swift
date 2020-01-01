//
//  String+CapitalizeFirstLetter.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-28.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        let firstLetter = prefix(1).uppercased()
        let rest = self.lowercased().dropFirst()
        
        return firstLetter + rest
    }
}
