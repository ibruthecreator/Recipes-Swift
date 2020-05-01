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
    
    // Make food prediction from an image
    func predictFood(fromImage image: UIImage, completion: @escaping (_ predictions: [Ingredient]) -> ()) {
        if let image = ClarifaiImage(image: image) {
            app?.getModelByID(modelID, completion: { (model, error) in
                model?.predict(on: [image]) { outputs, error in
                    if let outputs = outputs {
                        self.searchResults.removeAll()
                        
                        for output in outputs {
                            for concept in output.concepts {
                                var ingredient = Ingredient(name: concept.conceptName, image: nil)
                                // Only want reasonably plausible options that are not already in the users basket
                                if concept.score > 0.85 && !self.isInBasket(ingredient) {
                                    self.searchResults.append(ingredient)
                                }
                            }
                        }
                        
                        completion(self.searchResults)
                    }
                }
            })
        }
    }
    
    // MARK: - Fetch Auto Complete Results for Recipes
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
            }
        }
    }
    
    // MARK: - Get Single Image From Single Ingredient
    func getSingleIngredientImage(for ingredient: String, completion: @escaping (_ success: Bool, _ image: UIImage?) -> ()) {
        let query = "?apiKey=\(apiKey)&query=\(ingredient)&number=1" // number = 1 -> only return on result
        
        if let urlString = (autocompleteIngredientEndpoint + query).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        do {
                            let ingredientObject = try JSONDecoder().decode([Ingredient].self, from: data)
                            if let image = ingredientObject.first?.image {
                                Recipes.sharedInstance.downloadImage(from: image, onlyFileName: true) { (image) in
                                    completion(true, image)
                                }
                            } else {
                                completion(false, nil)
                            }
                        } catch let error {
                            print(error)
                            completion(false, nil)
                        }
                    }
                }.resume()
            }
        }
    }
    
    // This function checks to see whether one of the generated predictions is already in the user's basket
    // If it is, it will return false so that the same prediction isn't duplicated or redundantly shown
    func isInBasket(_ ingredient: Ingredient) -> Bool {
        return basket.contains(ingredient)
    }
    
    // Adds an ingredient to a basket and makes sure that it's not already there (no duplicates)
    // Adds to the *beginning* of the array
    func addToBasket(_ ingredient: Ingredient) {
        if !isInBasket(ingredient) {       // If basket doesn't contain ingredient already
            self.basket.insert(ingredient, at: 0)
        }
    }
    
    // Removes item from basket
    func removeFromBasket(_ ingredient: Ingredient) {
        // Set value of basket array to a copy of basket array where the
        // specified ingredient to be removed is removed from the array itaelf
        basket = basket.filter { $0.name != ingredient.name }
    }
    
    // Removes item from current predictions
    // Used so that the ingredient is immediately removed from ingredient collection view when it is added to the basket
    func removeFromPredictions(_ ingredient: Ingredient) {
        // Set value of predictions array to a copy of predictions array where the
        // specified ingredient to be removed is removed from the array itaelf
        searchResults = searchResults.filter { $0.name != ingredient.name }
    }
    
    // Clears basket and clears predicted ingredients
    // This will be called everytime the scan view controller is dismissed and then revisited
    func clearBasketAndPredictions() {
        self.basket.removeAll()
        self.searchResults.removeAll()
    }
}
