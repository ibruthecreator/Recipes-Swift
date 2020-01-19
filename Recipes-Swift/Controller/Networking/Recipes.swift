//
//  Recipes.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-01.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Recipes {
    static let sharedInstance = Recipes()
    
    var recipes: [Recipe] = []

    let findByIngredientsEndpoint = "https://api.spoonacular.com/recipes/findByIngredients"
    let informationBulkEndpoint = "https://api.spoonacular.com/recipes/informationBulk"

    // Fixed parameters - everything except ingredients
    let apiKey = "7845152a156345c9b7ffb9ea93a0b4ae"
    
    // MARK: - Fetch Recipes
    // This only gets information such as title, image, and the sorts
    // While this is sufficient, we need more details for each recipe in the case that the user clicks for more information
    // The API requires that we use two different endpoints, one that searches by ingredients and one that gets details for the recipe
    // We call a method that utilises the second endpoint once we are finished decoding the recipes returned from this endpoint
    func fetchRecipes(completion: @escaping (_ success: Bool) -> ()) {
        let allIngredients = Prediction.sharedInstance.basket.joined(separator: ",") // "," between words is how the API expects input
        
        let query = "?apiKey=\(apiKey)&ingredients=\(allIngredients)&number=5&ranking=1&ignorePantry=true"
        
        if let url = URL(string: findByIngredientsEndpoint + query) {
            do {
                let request = try URLRequest(url: url, method: .get)
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        do {
                            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                            
                            self.fetchAllRecipeInformation(recipes: recipes) { (success) in
                                completion(true)
                            }
                        } catch let error {
                            print(error)
                        }
                    }
                }.resume()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Fetch Recipe Information
    func fetchAllRecipeInformation(recipes: [Recipe], completion: @escaping (_ sucess: Bool) -> ()) {
        var recipeIDs: [String] = []
        
        for recipe in recipes {
            recipeIDs.append(String(recipe.id))
        }
         
        let recipeIDsQuery = recipeIDs.joined(separator: ",") // "," between words is how the API expects input
        let query = "?apiKey=\(apiKey)&ids=\(recipeIDsQuery)"
        
        if let url = URL(string: informationBulkEndpoint + query) {
            do {
                let request = try URLRequest(url: url, method: .get)
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        print("data")
                        do {
                            let recipesWithDetail = try JSONDecoder().decode([Recipe].self, from: data)
                            self.recipes = recipesWithDetail
                            
                            completion(true)
                        } catch let error {
                            print(error)
                        }
                    }
                }.resume()
            } catch {
                print(error)
            }
        }
    }
}
