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
    
    // MARK: - Update Content
    func updateContent() {
        if let ingredient = ingredient {
            // Set ingredient name label
            ingredientNameLabel.text = ingredient.name?.capitalized ?? "NaN"
            
            self.ingredientImageView.image = nil
            
            // Download image and place in image view
            Recipes.sharedInstance.downloadImage(from: ingredient.image ?? "none.jpg", onlyFileName: true) { (image) in
                self.ingredientImageView.image = image
            }
        }
    }

    // MARK: - Add Ingredient
    @IBAction func addIngredient(_ sender: Any) {
        if ingredient != nil {
            Ingredients.sharedInstance.addToBasket(ingredient!)
            delegate?.didAddIngredient()
        }
    }
}
