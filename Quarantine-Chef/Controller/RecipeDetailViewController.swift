//
//  RecipeDetailViewController.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-11.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var recipeCardContentView: RecipeContentView!
    @IBOutlet weak var recipeCardContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recipeCardContentViewWidthAnchor: NSLayoutConstraint!
    @IBOutlet weak var recipeCardContentViewTrailingAnchor: NSLayoutConstraint!
    @IBOutlet weak var recipeCardContentViewLeadingAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientsTableViewHeightAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var cookingPreparingStackView: UIStackView!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var preparingTimeLabel: UILabel!
    
    @IBOutlet weak var viewRecipeButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    
    var cellFrame: CGRect?
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = self
        
        setupViews()
        updateDetailContent()
    }

    // MARK: - Setup Views
    func setupViews() {
        recipeCardContentView.layer.shadowOpacity = 0.0
        closeButton.makeCircular()
        
        viewRecipeButton.layer.cornerRadius = 8
        
        ingredientsTableView.rowHeight = UITableView.automaticDimension
        ingredientsTableView.estimatedRowHeight = 42.5
        
        shareButton.layer.cornerRadius = 8
    }
    
    // Hide status bar for this VC alone
    override var prefersStatusBarHidden: Bool {
      return true
    }
    
    func layoutTableViews() {
        let ingredientsTableViewContentSize = ingredientsTableView.contentSize.height
        ingredientsTableViewHeightAnchor.constant = ingredientsTableViewContentSize
       
        self.view.layoutIfNeeded()  // Flush changes
    }
    
    /// Update recipe card with main recipe information (image + name). This is the same recipe content view as the table view in `RecipesViewController`
    func updateCard() {
        if let recipe = recipe {
            DispatchQueue.main.async {
                self.recipeCardContentView.recipe = recipe
                self.recipeCardContentView.updateContent()
                self.view.sendSubviewToBack(self.recipeCardContentView)
            }
        }
    }
    
    /// Update cooking time and preparing time labels with relevant information (if available)
    func updateDetailContent() {
        if let cookingTime = recipe?.cookingMinutes {
            cookingTimeLabel.text = "\(cookingTime) mins"
        } else {
            cookingTimeLabel.text = "N/A"
        }
        
        if let preparingTime = recipe?.preparationMinutes {
            preparingTimeLabel.text = "\(preparingTime) mins"
        } else {
            preparingTimeLabel.text = "N/A"
        }
    }
    
    @IBAction func dismissRecipe(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Opens URL for user to view original recipe source (if available)
    /// - Parameter sender: source that invoked the action (e.g. button)
    @IBAction func viewRecipe(_ sender: Any) {
        if let sourceURL = recipe?.sourceUrl {
            if let url = URL(string: sourceURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    displayURLError()
                }
            } else {
                displayURLError()
            }
        }
    }
    
    /// Present share sheet if the user decides to share the recipe via text or social media
    /// - Parameter sender: source that invoked the action (e.g. button)
    @IBAction func showShareSheet(_ sender: Any) {
        if let recipe = recipe, let sourceURL = recipe.sourceUrl, let url = URL(string: sourceURL) {
            let items: [Any] = ["Check out this recipe!", url]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
            
        } else {
            displayURLError()
        }
    }
    
    /// If a recipe does not have a URL for some reason, the user should know why the website is not opening or why they can't share a recipe.
    func displayURLError() {
        let alert = UIAlertController(title: "This recipe does not have it's own page", message: "Our apologies! But it seems like this recipe's webpage was lost.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipe?.extendedIngredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell
        
        cell.ingredient = self.recipe?.extendedIngredients?[indexPath.row]
        cell.updateContent()
        
        // Needs to be on the main thread or contentSize will be inaccurate sometimes
        DispatchQueue.main.async {
            self.layoutTableViews()
        }
    
        return cell
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension RecipeDetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 0.5, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 0.7, animationType: .dismiss)
    }
}
