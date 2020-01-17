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
    @IBOutlet weak var recipeContentView: RecipeContentView!
        
    var disabledHighlightedAnimation = false

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
        // TODO: - Remove Redundancies
        self.clipsToBounds = false
        self.contentView.layer.masksToBounds = false
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.clear
        
        // Since background view doesn't mask to bounds (in order to show shadows), we have to apply the corner radius to the image seperately
    }
    
    // MARK: - Freeze Animations
    func freezeAnimations() {
        animate(isHighlighted: true)
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
        animate(isHighlighted: false)
    }
    
    // Make it appears very responsive to touch when you hold on it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    // MARK: - Cell Bounce On Hold Animation
    func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
           if disabledHighlightedAnimation {
               return
           }
        let animationOptions: UIView.AnimationOptions = true
           ? [.allowUserInteraction] : []
           if isHighlighted {
               UIView.animate(withDuration: 0.5,
                              delay: 0,
                              usingSpringWithDamping: 1,
                              initialSpringVelocity: 0,
                              options: animationOptions, animations: {
                                self.transform = .init(scaleX: 0.94, y: 0.94)   // Bounce inwards
               }, completion: completion)
           } else {
               UIView.animate(withDuration: 0.5,
                              delay: 0,
                              usingSpringWithDamping: 1,
                              initialSpringVelocity: 0,
                              options: animationOptions, animations: {
                               self.transform = .identity
               }, completion: completion)
           }
       }
}

