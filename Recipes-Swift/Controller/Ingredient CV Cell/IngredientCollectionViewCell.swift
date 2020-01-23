//
//  IngredientCollectionViewCell.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-27.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class IngredientCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    var ingredient: String?
    
    var delegate: IngredientCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        setupViews()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        self.layer.cornerRadius = 8

        addButton.backgroundColor = UIColor.Theme.green
        addButton.makeCircular()
    }
    
    // MARK: - Update Label
    func updateLabel() {
        ingredientLabel.text = ingredient?.capitalized ?? "Ingredient"
    }
    
    // MARK: - Add Button
    @IBAction func addButtonWasPressed(_ sender: Any) {
        if let ingredient = ingredient {
            Prediction.sharedInstance.removeFromPredictions(ingredient)
            Prediction.sharedInstance.addToBasket(ingredient)
            delegate?.didAddIngredient()
        }
    }
    
}
