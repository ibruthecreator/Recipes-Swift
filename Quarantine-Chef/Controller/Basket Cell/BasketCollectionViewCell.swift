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
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var ingredient: Ingredient?
    
    var delegate: BasketCellDelegate?
    var isDarkMode: Bool = false
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        self.makeCircular()
        self.layer.masksToBounds = true // Clips off anything overflowing edges
        
        toggleDisplayMode()
    }

    func updateLabel() {
        toggleDisplayMode() // Incase dark mode set later
        ingredientLabel.text = ingredient?.name?.capitalized ?? "Ingredient"
    }
    
    func toggleDisplayMode() {
        if isDarkMode {
            blurView.effect = UIBlurEffect(style: .dark)
        } else {
            blurView.effect = UIBlurEffect(style: .light)
        }
    }
    
    /// Just an indicator to show that this ingredient was just added,
    /// This makes it more visible in the case that it was added by accident and also as a way to provide feedback to the user after adding
    func flashWhite() {
        let blackView = UIView(frame: self.frame)
        blackView.backgroundColor = UIColor.black
        
        self.addSubview(blackView)
        sendSubviewToBack(blackView)
        
        // Fade out after one second
        blackView.fadeOut(withDelay: 1.5)
    }
    
    /// Remove ingredient from basket
    @IBAction func removeFromBasket(_ sender: Any) {
        if let ingredient = ingredient {
            Ingredients.sharedInstance.removeFromBasket(ingredient)
            delegate?.didRemoveIngredient()
        }
    }
    
    // MARK: - Make Display
    /// Disables delete button if its a display only cell (on `RecipesViewController`, for example).
    func makeDisplayOnly() {
        deleteButton.isEnabled = true
        deleteButton.isHidden = true
        
        self.backgroundColor = UIColor.black
        self.ingredientLabel.textColor = UIColor.white
    }
}
