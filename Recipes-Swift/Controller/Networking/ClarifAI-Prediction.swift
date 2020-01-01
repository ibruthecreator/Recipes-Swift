//
//  ClarifAI-Prediction.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-27.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import Foundation
import Clarifai

class Prediction {
    static let sharedInstance = Prediction()
    
    let app = ClarifaiApp(apiKey: "a22af8ed477e4549b2ce6ae2dc6cac02")
    let modelID = "bd367be194cf45149e75f01d59f77ba7" // The ID of the public API we are using to analyze our image
    var predictions: [String] = []
    var basket: [String] = []
    
    // Make food prediction from an image
    func predictFood(fromImage image: UIImage, completion: @escaping (_ predictions: [String]) -> ()) {
        if let image = ClarifaiImage(image: image) {
            app?.getModelByID(modelID, completion: { (model, error) in
                model?.predict(on: [image]) { outputs, error in
                    if let outputs = outputs {
                        self.predictions.removeAll()
                        
                        for output in outputs {
                            for concept in output.concepts {
                                // Only want reasonably plausible options that are not already in the users basket
                                if concept.score > 0.85 && !self.isInBasket(concept.conceptName) {
                                    self.predictions.append(concept.conceptName)
                                }
                            }
                        }
                        
                        completion(self.predictions)
                    }
                }
            })
        }
    }
    
    // This function checks to see whether one of the generated predictions is already in the user's basket
    // If it is, it will return false so that the same prediction isn't duplicated or redundantly shown
    func isInBasket(_ ingredient: String) -> Bool {
        return basket.contains(ingredient)
    }
    
    // Adds an ingredient to a basket and makes sure that it's not already there (no duplicates)
    func addToBasket(_ ingredient: String) {
        if !isInBasket(ingredient) {       // If basket doesn't contain ingredient already
            self.basket.append(ingredient)
        }
    }
    
    // Removes item from basket
    func removeFromBasket(_ ingredient: String) {
        // Set value of basket array to a copy of basket array where the
        // specified ingredient to be removed is removed from the array itaelf
        basket = basket.filter { $0 != ingredient }
    }
    
    // Removes item from current predictions
    // Used so that the ingredient is immediately removed from ingredient collection view when it is added to the basket
    func removeFromPredictions(_ ingredient: String) {
        // Set value of predictions array to a copy of predictions array where the
        // specified ingredient to be removed is removed from the array itaelf
        predictions = predictions.filter { $0 != ingredient }
    }
}
