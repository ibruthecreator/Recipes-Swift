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

    let endpoint = "https://api.edamam.com/search"
    
    let app_id = "ef94e304"
    let app_key = "7cb742a697f56f62602761945b7b0fc4"
    
    // MARK: - Fetch Recipes
    func fetchRecipes(completion: @escaping (_ success: Bool) -> ()) {
        let allIngredients = Prediction.sharedInstance.basket.joined(separator: " and ") // "and" keyword between words is how the API expects input
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        let parameters: Parameters = ["app_id": app_id, "app_key": app_key, "q": allIngredients]
        
        //create the url with URL
        if let url = URL(string: endpoint) {
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { (dataResponse) in
                if let error = dataResponse.error {
//                    completion(nil, nil, nil, "Error")
                    print(error.localizedDescription)
                    return
                }
                if let data = dataResponse.data {
                    do {
                        let recipesJSON = try JSON(data: data)
                        if let hits = recipesJSON["hits"].array {
                            for hit in hits {
                                let recipe = hit["recipe"]
                                
                                let recipeRaw = try recipe.rawData()
                                let decoder = JSONDecoder()
                                
                                do {
                                    let recipe = try decoder.decode(Recipe.self, from: recipeRaw)
                                    self.recipes.append(recipe)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
//                        if let array = recipes.array {
//                            for recipe in array {
//                                let jsonData = try recipe.rawData()
//                                print(recipe)
//                                print("------")
//                                let decoder = JSONDecoder()
//                                do {
//                                    let recipe = try decoder.decode(Recipe.self, from: jsonData)
//                                    self.recipes.append(recipe)
//                                } catch {
//                                    print(error.localizedDescription)
//                                }
//                            }
//                        }
                        completion(true)
                    } catch {
                        print(error)
                        completion(false)
                    }
                }
            }
        }
    }
}
