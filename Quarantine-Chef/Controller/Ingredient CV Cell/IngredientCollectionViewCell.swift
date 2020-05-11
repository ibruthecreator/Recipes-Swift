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
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    var ingredient: Ingredient?
    var isOnSearchView: Bool = false
    var delegate: BasketCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        setupViews()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        self.layer.cornerRadius = 8

        addButton.backgroundColor = UIColor.black
        addButton.makeCircular()
        
        if isOnSearchView {
            addButton.setTitle("Remove", for: .normal)
        } else {
            addButton.setTitle("Add", for: .normal)
        }
    }
    
    func updateLabel() {
        setupViews()    // Incase `isOnSearchView` was toggled after at some point
        
        ingredientLabel.text = ingredient?.name?.capitalized ?? "Ingredient"
    }
    
    /// Add button was pressed, checks to see if ingredient is not nil, then removes from prediction list and adds it to basket.
    @IBAction func addButtonWasPressed(_ sender: Any) {
        if let ingredient = ingredient {
            Ingredients.sharedInstance.removeFromPredictions(ingredient)
            Ingredients.sharedInstance.addToBasket(ingredient)
            delegate?.didAddIngredient()
        }
    }
}
