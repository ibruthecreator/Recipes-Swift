//
//  RecipeDetailViewController.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-11.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var recipeCardContentView: RecipeContentView!
    @IBOutlet weak var recipeCardContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recipeCardContentViewWidthAnchor: NSLayoutConstraint!
    @IBOutlet weak var recipeCardContentViewTrailingAnchor: NSLayoutConstraint!
    @IBOutlet weak var recipeCardContentViewLeadingAnchor: NSLayoutConstraint!
    
    var cellFrame: CGRect?
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = self
        
        setupViews()
    }

    // MARK: - Setup Views
    func setupViews() {
        recipeCardContentView.layer.shadowOpacity = 0.0
        closeButton.makeCircular()
    }
    
    // Hide status bar for this VC alone
    override var prefersStatusBarHidden: Bool {
      return true
    }
    
    // MARK: - Update Card
    func updateCard() {
        if let recipe = recipe {
            DispatchQueue.main.async {
                self.recipeCardContentView.recipe = recipe
                self.recipeCardContentView.updateContent()
                self.view.sendSubviewToBack(self.recipeCardContentView)
            }
        }
    }
    
    // MARK: - Dismiss VC
    @IBAction func dismissRecipe(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RecipeDetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(animationDuration: 0.5, animationType: .present)
    }
    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return AnimationController(animationDuration: 0.4, animationType: .dismiss)
//    }
}
