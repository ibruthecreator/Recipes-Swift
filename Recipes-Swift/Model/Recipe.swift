//
//  Recipe.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-02.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class Recipe: Codable {
    var id: Int          // ID of the recipe
    var title: String    // Title of the Recipe
    var image: String    // Original URL of the image
    var displayImage: String {
        // Gets a larger version of the recipe image, which by default is served as a smaller image
        // This replaces the dimensions of the image, which is in the URL of the image itslef
        return image.replacingOccurrences(of: "312x231", with: "636x393")
    }                    // The display image of the URL, with a larger size
    var vegetarian: Bool?
    var sourceUrl: String?
    var sourceName: String?
    var cuisines: [String]?
    var cookingMinutes: Int?
    var preparationMinutes: Int?
    var extendedIngredients: [ExtendedIngredient]?
}

class ExtendedIngredient: Codable {
    var name: String?
    var unit: String?
    var amount: Double?
}
