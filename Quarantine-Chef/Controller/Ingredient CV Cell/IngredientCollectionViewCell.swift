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
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var addDeleteButton: UIButton!
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

        addDeleteButton.backgroundColor = UIColor.black
        addDeleteButton.makeCircular()
        
        if isOnSearchView {
            addDeleteButton.setTitle("Remove", for: .normal)
        } else {
            addDeleteButton.setTitle("Add", for: .normal)
        }
    }
    
    // MARK: - Update Label
    func updateLabel() {
        setupViews()    // Incase `isOnSearchView` was toggled after at some point
        
        ingredientLabel.text = ingredient?.name?.capitalized ?? "Ingredient"
    }
    
    // MARK: - Update Image
    func updateImage() {
        self.ingredientImageView.image = nil
        
        if let ingredientName = ingredient?.name {
            Ingredients.sharedInstance.getSingleIngredientImage(for: ingredientName) { (success, image) in
                if success, let image = image {
                    DispatchQueue.main.async {
                        self.ingredientImageView.image = image
                    }
                }
            }
        }
    }
    
    // MARK: - Add Button
    @IBAction func addDeleteButtonWasPressed(_ sender: Any) {
        if let ingredient = ingredient {
            Ingredients.sharedInstance.removeFromPredictions(ingredient)
            Ingredients.sharedInstance.addToBasket(ingredient)
            delegate?.didAddIngredient()
        }
    }
    
}
