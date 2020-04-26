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
    var delegate: IngredientCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Setup Views
    func setupViews() {
        addButton.makeCircular()
    }
    
    // MARK: - Update Content
    func updateContent() {
        if let ingredient = ingredient {
            // Set ingredient name label
            ingredientNameLabel.text = ingredient.name?.uppercased() ?? "NaN"
            
            // Download image and place in image view
            Recipes.sharedInstance.downloadImage(from: ingredient.image ?? "none.jpg", onlyFileName: true) { (image) in
                self.ingredientImageView.image = image
            }
        }
    }

    // MARK: - Add Ingredient
    @IBAction func addIngredient(_ sender: Any) {
        if let ingredientName = ingredient?.name {
            Prediction.sharedInstance.addToBasket(ingredientName)
            delegate?.didAddIngredient()
        }
    }
}
