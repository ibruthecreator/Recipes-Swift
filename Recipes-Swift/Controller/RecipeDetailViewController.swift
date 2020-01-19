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
    
    @IBOutlet weak var quickInformationTableView: UITableView!
    @IBOutlet weak var quickInformationTableViewHeightAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var cookingPreparingStackView: UIStackView!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var preparingTimeLabel: UILabel!
    
    @IBOutlet weak var viewRecipeButton: UIButton!
    
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
        viewRecipeButton.backgroundColor = UIColor.Theme.green
        
        quickInformationTableView.rowHeight = UITableView.automaticDimension
        quickInformationTableView.estimatedRowHeight = 42.5
    }
    
    // Hide status bar for this VC alone
    override var prefersStatusBarHidden: Bool {
      return true
    }
    
    // MARK: - Update Card
    func updateCard() {
        if let recipe = recipe {
            DispatchQueue.main.async {
                self.recipeCardContentView.recipe = recipe
                self.recipeCardContentView.updateContent()
                self.view.sendSubviewToBack(self.recipeCardContentView)
            }
        }
    }
    
    // MARK: - Update Detail Content
    func updateDetailContent() {
        if let cookingTime = recipe?.cookingMinutes {
            cookingTimeLabel.text = "\(cookingTime) MINS"
        } else {
            cookingTimeLabel.text = "N/A"
        }
        
        if let preparingTime = recipe?.preparationMinutes {
            preparingTimeLabel.text = "\(preparingTime) MINS"
        } else {
            preparingTimeLabel.text = "N/A"
        }
    }
    
    // MARK: - Dismiss VC
    @IBAction func dismissRecipe(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Recipe
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
    
    // MARK: - Display URL error
    func displayURLError() {
        let alert = UIAlertController(title: "This recipe does not have it's own page", message: "Our apologies! But it seems like this recipe's webpage was lost.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table View Delegate Methods
extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipe?.extendedIngredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension RecipeDetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 0.5, animationType: .present)
    }
    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return AnimationController(animationDuration: 0.4, animationType: .dismiss)
//    }
}
