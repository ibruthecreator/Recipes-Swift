//
//  OnboardingCollectionViewCell.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-30.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        setupViews()
    }
    
    // MARK: - Setup Views
    func setupViews() {
        // Nothing
    }
}
