//
//  Recipe.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-02.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import Foundation

class Recipe: Codable {
    var label: String
    var image: String
    var ingredientLines: [String]
    var totalTime: Int
    var url: String
    var source: String
}
