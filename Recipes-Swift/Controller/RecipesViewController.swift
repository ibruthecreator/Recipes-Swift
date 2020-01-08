//
//  RecipesViewController.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-01.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var recipesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        fetchRecipes()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        recipesTableView.showsHorizontalScrollIndicator = false
        recipesTableView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Fetch Ingredients
    func fetchRecipes() {
        Recipes.sharedInstance.fetchRecipes { (success) in
            if success {
                self.recipesTableView.reloadData()
                
                return
            }
            
            // TODO: Display error message
        }
    }
}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Recipes.sharedInstance.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        
        // Assigns recipe to table view cell and updates content on the cell
        let recipe = Recipes.sharedInstance.recipes[indexPath.row]
        cell.recipe = recipe
        cell.updateContent()
        
        return cell
    }
}
