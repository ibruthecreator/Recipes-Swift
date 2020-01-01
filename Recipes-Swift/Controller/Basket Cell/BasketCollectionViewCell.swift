//
//  BasketCollectionViewCell.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-29.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class BasketCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var ingredientLabel: UILabel!
    
    var ingredient: String?
    
    var delegate: BasketCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        self.layer.cornerRadius = self.frame.height / 2
    }

    // MARK: - Update Label
    func updateLabel() {
        ingredientLabel.text = ingredient?.capitalizeFirstLetter() ?? "Ingredient"
    }
    
    // MARK: - Remove From Basket
    @IBAction func removeFromBasket(_ sender: Any) {
        if let ingredient = ingredient {
            Prediction.sharedInstance.removeFromBasket(ingredient)
            delegate?.didRemoveIngredient()
        }
    }
}
