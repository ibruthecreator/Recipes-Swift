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
    
    var justAdded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        self.makeCircular()
        self.layer.masksToBounds = true // Clips off anything overflowing edges
    }

    // MARK: - Update Label
    func updateLabel() {
        ingredientLabel.text = ingredient?.capitalizeFirstLetter() ?? "Ingredient"
    }
    
    // MARK: - Flash Green
    // Just an indicator to show that this ingredient was just added,
    // This makes it more visible in the case that it was added by accident and also as a way to provide feedback to the user after adding
    func flashGreen() {
        let greenView = UIView(frame: self.frame)
        greenView.backgroundColor = UIColor.Theme.green
        
        self.addSubview(greenView)
        sendSubviewToBack(greenView)
        
        // Fade out after one second
        greenView.fadeOut(withDelay: 1.5)
        
        justAdded = false
    }
    
    // MARK: - Remove From Basket
    @IBAction func removeFromBasket(_ sender: Any) {
        if let ingredient = ingredient {
            Prediction.sharedInstance.removeFromBasket(ingredient)
            delegate?.didRemoveIngredient()
        }
    }
}
