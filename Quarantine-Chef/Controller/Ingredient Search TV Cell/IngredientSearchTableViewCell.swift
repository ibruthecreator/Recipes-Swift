//
//  IngredientSearchTableViewCell.swift
//  Quarantine-Chef
//
//  Created by Mohammed Ibrahim on 2020-04-26.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class IngredientSearchTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Variables
    var ingredient: Ingredient?
    var delegate: BasketCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Setup Views
    func setupViews() {
        addButton.layer.cornerRadius = addButton.frame.height / 2
    }
    
    func clearImage() {
        self.ingredientImageView.image = nil
    }
    
    func updateContent() {
        if let ingredient = ingredient {
            // Set ingredient name label
            ingredientNameLabel.text = ingredient.name?.capitalized ?? "NaN"
            
            // Download image and place in image view
            Recipes.sharedInstance.downloadImage(from: ingredient.image ?? "none.jpg", onlyFileName: true) { (image) in
                self.ingredientImageView.image = image
            }
        }
    }

    /// Add button was pressed, checks to see if ingredient is not nil, then removes from prediction list and adds it to basket.
    @IBAction func addIngredient(_ sender: Any) {
        if let ingredient = ingredient {
            Ingredients.sharedInstance.addToBasket(ingredient)
            Ingredients.sharedInstance.removeFromPredictions(ingredient)
            delegate?.didAddIngredient()
        }
    }
}
