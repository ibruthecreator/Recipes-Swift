//
//  Recipes.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-01.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit    // UIKit only for UIImage type below

class Recipes {
    static let sharedInstance = Recipes()
    
    var recipes: [Recipe] = []
    
    let findByIngredientsEndpoint = "https://api.spoonacular.com/recipes/findByIngredients"
    let informationBulkEndpoint = "https://api.spoonacular.com/recipes/informationBulk"
    let autocompleteIngredientEndpoint = "https://api.spoonacular.com/food/ingredients/autocomplete"
    
    let ingredientImageURL = "https://spoonacular.com/cdn/ingredients_500x500/"

    // Fixed parameters - everything except ingredients
    let apiKey = "7845152a156345c9b7ffb9ea93a0b4ae"
    
    // Store images for cache, prevents flickering in transition
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Fetch Recipes
    // This only gets information such as title, image, and the sorts
    // While this is sufficient, we need more details for each recipe in the case that the user clicks for more information
    // The API requires that we use two different endpoints, one that searches by ingredients and one that gets details for the recipe
    // We call a method that utilises the second endpoint once we are finished decoding the recipes returned from this endpoint
    func fetchRecipes(completion: @escaping (_ success: Bool) -> ()) {
        // 'compactMap' makes the basket array into an array of strings, which can then be concatenated with 'joined' ("," between words is how the API expects input)
        let allIngredients = Ingredients.sharedInstance.basket.compactMap{$0.name}.joined(separator: ",")
        
        let query = "?apiKey=\(apiKey)&ingredients=\(allIngredients)&number=5&ranking=1&ignorePantry=true"
        
        // Add Percent Encoding is needed in case the ingredients any of the ingredients have spaces
        // For example, "Bell Pepper" raw in the URL would return the error, whereas "Bell%20Pepper" has the same value but is URL compatible
        if let urlString = (findByIngredientsEndpoint + query).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            print(urlString)
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        // TODO: - Handle error for typemismatch when no results are returned.
                        // To test: - Add only "cake" through the photo scanner and click continue; check logs.
                        do {
                            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                            self.fetchAllRecipeInformation(recipes: recipes) { (success) in
                                completion(true)
                            }
                        } catch let error {
                            print(error)
                        }
                    } else {
                    }
                }.resume()
            }
        }
    }
    
    // MARK: - Fetch Recipe Information
    func fetchAllRecipeInformation(recipes: [Recipe], completion: @escaping (_ success: Bool) -> ()) {
        var recipeIDs: [String] = []
        
        for recipe in recipes {
            recipeIDs.append(String(recipe.id))
        }
         
        let recipeIDsQuery = recipeIDs.joined(separator: ",") // "," between words is how the API expects input
        let query = "?apiKey=\(apiKey)&ids=\(recipeIDsQuery)"
        
        if let url = URL(string: informationBulkEndpoint + query) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let recipesWithDetail = try JSONDecoder().decode([Recipe].self, from: data)
                        self.recipes = recipesWithDetail
                        
                        completion(true)
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    /// Downloads a recipe or ingredient image provided by the API, provided a URL, and returns a UIImage
    /// - Parameters:
    ///   - imageFile: Name of the file and extension
    ///   - onlyFileName: Boolean which is true if the provided image file parameter is only the name and extension and false if the provided image file parameter includes the entire email
    ///   - completion: Returns a UIImage if successful
    func downloadImage(from link: String, onlyFileName: Bool = false, completion: @escaping (_ image: UIImage) -> () = {_ in } ) {
        // If its only the file name and extension, add the ingredient image URL to the former end of the URL as this may be an ingredient image.
        // API only serves file name and extension for ingredient API
        guard let url = URL(string: onlyFileName ? ingredientImageURL + link : link) else {
            // URL error
            return
        }
        
        // Try to see if image has already been cached
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            print("Cached!")
            completion(cachedImage)
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let httpURLResponse = response as? HTTPURLResponse,
                      httpURLResponse.statusCode == 200, error == nil,
                      let data = data,
                      let image = UIImage(data: data) else {
                        return // Error
                }
                
                // If not already cached, cache now for easy retrieval later
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)

                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
    }
}
