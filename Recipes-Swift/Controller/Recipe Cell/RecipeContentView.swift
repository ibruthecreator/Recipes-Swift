//
//  RecipeContentView.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-15.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

@IBDesignable final class RecipeContentView: UIView, NibLoadable {

    // MARK: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var labelWidthAnchor: NSLayoutConstraint!
    @IBOutlet weak var labelTrailingAnchor: NSLayoutConstraint!

    var recipe: Recipe?
    var image: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()   // Loads components from nib file
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()   // Loads components from nib file
        setupViews()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        self.recipeImageView.contentMode = .scaleAspectFill
        
        self.containerView.layer.cornerRadius = 18
        self.containerView.layer.masksToBounds = true
        
        // Remove background color (originally white)
        self.backgroundColor = .clear
        self.parentView.backgroundColor = .clear
        
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 18
    }
    
    func updateContent(includingImage: Bool = true) {
        if let recipe = recipe {
            if includingImage {
                Recipes.sharedInstance.downloadImage(from: recipe.displayImage) { (image) in
                    self.recipeImageView.image = image
                }
            }
            
            sourceLabel.text = recipe.sourceName
            
            if recipe.vegetarian ?? false {
                recipeNameLabel.text = "🌱 \(recipe.title?.capitalized ?? "Recipe")"
                return
            }
            
            recipeNameLabel.text = recipe.title
        }
    }
    
    // Disable Trailing anchor and fix the width of the label
    func fixLabelWidth(width: CGFloat) {
        labelWidthAnchor.constant = width
        labelTrailingAnchor.isActive = false
    }

}
