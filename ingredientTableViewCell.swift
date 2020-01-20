//
//  ingredientTableViewCell.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-19.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class ingredientTableViewCell: UITableViewCell {
    
    var ingredient: ExtendedIngredient?
    
    @IBOutlet weak var ingredientAmountLabel: UILabel!
    @IBOutlet weak var ingredientNameLabel: UILabel!
    
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
        ingredientAmountLabel.textColor = UIColor.Theme.green
    }
    
    // MARK: - Update Content
    func updateContent() {
        if let ingredient = ingredient {
            if let amount = ingredient.amount,
                let name = ingredient.name,
                let unit = ingredient.unit {
                ingredientAmountLabel.text = String(format: "%.2f", amount) // Grounding decimal places, sometimes values are irrational
                ingredientNameLabel.text = "\(unit) \(name)"
            } else {
                print("Empty")
            }
            
        }
    }
}
