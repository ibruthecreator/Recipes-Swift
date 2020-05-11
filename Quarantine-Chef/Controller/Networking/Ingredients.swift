//
//  ClarifAI-Prediction.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-27.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import Foundation
import Clarifai

class Ingredients {
    static let sharedInstance = Ingredients()
    
    let app = ClarifaiApp(apiKey: "a22af8ed477e4549b2ce6ae2dc6cac02")
    let modelID = "bd367be194cf45149e75f01d59f77ba7" // The ID of the public API we are using to analyze our image
    var searchResults: [Ingredient] = []
    var basket: [Ingredient] = []
    
    // Spoontacular API - needed here for autocomplete functionality
    let autocompleteIngredientEndpoint = "https://api.spoonacular.com/food/ingredients/autocomplete"
    let apiKey = "7845152a156345c9b7ffb9ea93a0b4ae"
    
    /// Make food prediction from an image
    /// - Parameters:
    ///   - image: image used to predict food
    ///   - completion: completion handler to fire once action is completed in any degree
    /// - Returns: returns ingredient predictions based on image
    func predictFood(fromImage image: UIImage, completion: @escaping (_ success: Bool) -> ()) {
        if let image = ClarifaiImage(image: image) {
            app?.getModelByID(modelID, completion: { (model, error) in
                model?.predict(on: [image]) { outputs, error in
                    if let outputs = outputs {
                        self.searchResults.removeAll()
                        
                        for output in outputs {
                            for concept in output.concepts {
                                let ingredient = Ingredient(name: concept.conceptName, image: nil)
                                // Only want reasonably plausible options that are not already in the users basket
                                if concept.score > 0.85 && !self.isInBasket(ingredient) {
                                    self.searchResults.append(ingredient)
                                }
                            }
                        }
                        
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            })
        } else {
            completion(false)
        }
    }
    
    /// Fetch auto complete results for recipes from a string, if a user decides to search manually for their ingredients.
    /// - Parameters:
    ///   - text: text to search ingredients by
    ///   - limit: limit of ingredients to return, default is 8
    ///   - completion: completion handler to fire once action is completed in any degree
    /// - Returns: return true or false depending on if query ran successfully
    func autocompleteIngredients(from text: String, limit: Int = 8, completion: @escaping (_ success: Bool) -> ()) {
        let query = "?apiKey=\(apiKey)&query=\(text)&number=\(limit)"
        self.searchResults.removeAll()
        
        if let urlString = (autocompleteIngredientEndpoint + query).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        do {
                            let ingredients = try JSONDecoder().decode([Ingredient].self, from: data)
                            self.searchResults = ingredients.filter({ (ingredient) -> Bool in
                                    // Leave in array only if it is not already in basket (!)
                                    return !self.isInBasket(ingredient)
                            }) // Remove predictions that are already in basket
                            
                            // TODO: - Apply above filter logic to the clarifAI predictions as well
                            
                            completion(true)
                        } catch {
                            completion(false)
                        }
                    }
                }.resume()
            } else {
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
    /// This function checks to see whether one of the generated predictions is already in the user's basket. If it is, it will return false so that the same prediction isn't duplicated or redundantly shown
    /// - Parameter ingredient: Ingredient in question for whether or not it exists already in the basket
    /// - Returns: true if basket contains ingredient, false otherwise
    func isInBasket(_ ingredient: Ingredient) -> Bool {
        return basket.contains(ingredient)
    }
    
    /// Adds an ingredient to a basket and makes sure that it's not already there (no duplicates) Adds to the beginning of the array
    /// - Parameter ingredient: Ingredient to be added
    func addToBasket(_ ingredient: Ingredient) {
        if !isInBasket(ingredient) {       // If basket doesn't contain ingredient already
            self.basket.insert(ingredient, at: 0)
        }
    }
    
    /// Removesa single ingredient from the user's basket
    /// - Parameter ingredient: Ingredient to be removed from basket
    func removeFromBasket(_ ingredient: Ingredient) {
        // Set value of basket array to a copy of basket array where the
        // specified ingredient to be removed is removed from the array itaelf
        basket = basket.filter { $0.name != ingredient.name }
    }
    
    /// Removes item from current predictions. Used so that the ingredient is immediately removed from ingredient collection view when it is added to the basket
    /// - Parameter ingredient: Ingredient to be removed from predictions
    func removeFromPredictions(_ ingredient: Ingredient) {
        // Set value of predictions array to a copy of predictions array where the
        // specified ingredient to be removed is removed from the array itaelf
        searchResults = searchResults.filter { $0.name != ingredient.name }
    }
    
    /// Clears basket and clears predicted ingredients. This will be called everytime the scan view controller is dismissed and then revisited
    func clearBasketAndPredictions() {
        self.basket.removeAll()
        self.searchResults.removeAll()
    }
}
