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
    
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet weak var ingredientsCollectionViewHeightConstraint: NSLayoutConstraint!
    
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
        
        ingredientsCollectionView.register(UINib(nibName: "BasketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "basketCell")
    }
    
    // MARK: - Fetch Ingredients
    func fetchRecipes() {
        Recipes.sharedInstance.fetchRecipes { (success) in
            if success {
                DispatchQueue.main.async {
                    self.recipesTableView.reloadData()
                }
                
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
    
    // MARK: - Layout Collection View
    func layoutCollectionView() {
        let ingredientsContentSize = ingredientsCollectionView.contentSize.height
        ingredientsCollectionViewHeightConstraint.constant = ingredientsContentSize
    }
    
    // MARK: - Close
    @IBAction func close(_ sender: Any) {
        // TODO: - Maybe have an alert asking if the user really wants to leave, just in case it was an accident
        
        // Empty everything
        Recipes.sharedInstance.recipes.removeAll()
        Prediction.sharedInstance.predictions.removeAll()
        Prediction.sharedInstance.basket.removeAll()
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Table View Delegate Methods
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
        // Assign "small" frame to view controller
        let cell = tableView.cellForRow(at: indexPath) as! RecipeTableViewCell
        
        cell.animate(isHighlighted: true) { (success) in
            // Relative frame for recipe box
            let currentFrame = cell.recipeContentView.frame
            
            // Calculate original frame
            let originalSize = CGSize(width: currentFrame.width * (100/94), height: currentFrame.height * (100/94))
            
            let widthDifference = originalSize.width - currentFrame.width
            let heightDifference = originalSize.height - currentFrame.height
            
            let originalOrigin = CGPoint(x: currentFrame.origin.x - (widthDifference / 2), y: currentFrame.origin.y - (heightDifference / 2))
            
            let recipeBoxRelativeToCellFrame = CGRect(origin: originalOrigin, size: originalSize)
            let recipeBoxRelativeToTableViewFrame = tableView.convert(recipeBoxRelativeToCellFrame, from: cell)
            let recipeBoxFrame = self.view.convert(recipeBoxRelativeToTableViewFrame, from: tableView)
            
            guard let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "recipeDetailView") as? RecipeDetailViewController else {
                return
            }

            // Send frame information
            // This is the original frame fof the cell, when it is untransformed (shrinked from tap)
            destinationVC.cellFrame = recipeBoxFrame
            
            // Send content
            destinationVC.recipe = cell.recipeContentView.recipe
            destinationVC.updateCard()
                    
            destinationVC.modalPresentationStyle = .fullScreen
            
            // Give time for touches began animation to finish
            self.present(destinationVC, animated: true, completion: {
                cell.animate(isHighlighted: false)
            })
        }
    }
}

// MARK: - Collection View Delegate Methods
extension RecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Prediction.sharedInstance.basket.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basketCell", for: indexPath) as! BasketCollectionViewCell
        
        let ingredient = Prediction.sharedInstance.basket[indexPath.row]
        cell.ingredient = ingredient
        cell.updateLabel()

        cell.backgroundColor = UIColor.Theme.green
        
        cell.makeDisplayOnly()
        
        DispatchQueue.main.async {
            self.layoutCollectionView()
        }
    
        return cell
    }
}
