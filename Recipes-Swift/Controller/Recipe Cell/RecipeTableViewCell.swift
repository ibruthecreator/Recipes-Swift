//
//  RecipeTableViewCell.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-02.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    var recipe: Recipe!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Setup Views
    func setupViews() {
        self.layer.cornerRadius = 18
        
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
    
    // MARK: - Update Cell Content
    // with recipe image and name
    func updateContent() {
        recipeLabel.text = recipe.label
        print(recipe.image)
        recipeImage.download(from: recipe.image)
    }
    
}
