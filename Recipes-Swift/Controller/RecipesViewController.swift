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
    @IBOutlet weak var recipesTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedRecipeFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        fetchRecipes()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        addBlurredStatusBar()
        
        recipesTableView.showsHorizontalScrollIndicator = false
        recipesTableView.showsVerticalScrollIndicator = false
        
        recipesTableView.rowHeight = UITableView.automaticDimension
        recipesTableView.estimatedRowHeight = 450
        
        recipesTableView.layer.masksToBounds = false
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // Add clear view to the background view of the cell.
        // This is so selection of a cell isn't gray
        // Making selection = none breaks animation logic, so this is a better solution
        let clearView = UIView()
        clearView.backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectedBackgroundView = clearView
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
    
    // MARK: - Layout Table View
    func layoutTableViews() {
        let recipesContentSize = recipesTableView.contentSize.height
        recipesTableViewHeightConstraint.constant = recipesContentSize
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
        cell.recipeContentView.recipe = recipe
        cell.recipeContentView.updateContent()
        
        cell.contentView.autoresizingMask = .flexibleHeight
        
        // Needs to be on the main thread or contentSize will be inaccurate sometimes
        DispatchQueue.main.async {
            self.layoutTableViews()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: "recipeDetailView") as? RecipeDetailViewController else {
            return
        }
        
        // Assign "small" frame to view controller
        let cell = tableView.cellForRow(at: indexPath) as! RecipeTableViewCell

        // Relative frame for recipe box
        let recipeBoxFrame = cell.recipeContentView.frame
        let recipeBoxRelativeToTableViewFrame = tableView.convert(recipeBoxFrame, from: cell)

        // Send frame information
        destinationVC.cellFrame = self.view.convert(recipeBoxRelativeToTableViewFrame, from: tableView)
        
        // Freeze highlighted state (or else it will bounce back)
        // At this point, the cell will be "inwards"
        cell.freezeAnimations()
        cell.contentView.isHidden = true    // TODO: - This sometimes causes a flicker due to a delay between hiding the cell and displaying the matching destination VC, explore possible solutions

        // Send content
        destinationVC.recipe = cell.recipeContentView.recipe
        destinationVC.updateCard()

        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true) {
            cell.contentView.isHidden = false
            cell.unfreezeAnimations()
        }
    }
}
