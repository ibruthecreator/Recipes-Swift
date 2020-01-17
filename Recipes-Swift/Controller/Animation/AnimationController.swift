//
//  AnimationController.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-11.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class AnimationController: NSObject {
    private let animationDuration: Double
    private let animationType: AnimationType
    private var frameOfCellBox: CGRect?
    
    // Two types of animation types, one to open a detail view controller and one to dismiss it
    enum AnimationType {
        case present
        case dismiss
    }
    
    // MARK: - Initialization
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get the view controller we are going to, and the view controller we are coming from
        guard let toViewController = transitionContext.viewController(forKey: .to) as? RecipeDetailViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
        }
        

        // Get frame of selected recipe
        guard let selectedRecipeFrame = toViewController.cellFrame else {
            transitionContext.completeTransition(false)
            return
        }
        
        switch animationType {
            case .present:
                transitionContext.containerView.addSubview(toViewController.view)
                presentAnimation(with: transitionContext, viewToAnimate: toViewController.view, fromFrame: selectedRecipeFrame)
                
            case .dismiss:
                transitionContext.containerView.addSubview(toViewController.view)
                transitionContext.containerView.addSubview(fromViewController.view)
//                dismissAnimation(with: transitionContext, viewToAnimate: fromViewController.view, toFrame: <#T##CGRect#>)
        }
    }
    
    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate view: UIView, fromFrame frame: CGRect) {
        let originalFrame = view.frame  // Target's original frame in the "from" view controller, which is essentially full screen
        let originalBounds = view.bounds // VC's bounds in its own coordinate system
                
        guard let detailView = transitionContext.viewController(forKey: .to) as? RecipeDetailViewController else {
            transitionContext.completeTransition(false)
            return
        }
        
        
        view.frame = frame
        
        /*
        let sizeDifference = (view.bounds.size.width - frame.size.width) / 2
        view.bounds = CGRect(origin: CGPoint(x: sizeDifference, y: 0), size: view.bounds.size)  // Same size, centered
        */
        
        detailView.recipeCardContentViewLeadingAnchor.isActive = false
        detailView.recipeCardContentViewTrailingAnchor.isActive = false
        detailView.recipeCardContentViewWidthAnchor.constant = frame.width
        detailView.recipeCardContentViewHeightConstraint.constant = frame.height
        detailView.recipeCardContentView.fixLabelWidth(width: frame.width - (13*2))
        
        detailView.recipeCardContentView.layoutIfNeeded()

        detailView.view.layoutIfNeeded()
        
        view.layer.cornerRadius = 18
        view.layer.shadowOpacity = 0.12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 18
        
        view.layoutIfNeeded()
        view.layoutSubviews()
        
        frameOfCellBox = frame // Save this frame for later when dismissing so that the cell can go back to its original position
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            // Bounce "inwards"
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                view.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
                
                view.layoutIfNeeded()
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4) {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
                view.transform = CGAffineTransform(translationX: 0, y: -100)    // For some reason translation transform didn't work, so updating the frame is the way to go
                
                view.layoutIfNeeded()
            }
            
            // Go up and bounce "outwards"
            // Grow out
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                view.frame = originalFrame
                view.bounds = originalBounds
                
                detailView.recipeCardContentViewWidthAnchor.constant = originalFrame.width
                detailView.recipeCardContentView.containerView.layer.cornerRadius = 0
                detailView.recipeCardContentView.layer.shadowOpacity = 0.0
                
                view.layoutIfNeeded()
                                
                view.layer.cornerRadius = 0
            }
        }) { (completed) in
            transitionContext.completeTransition(true)
        }
    }
    
    func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate view: UIView, toFrame frame: CGRect) {
        let finalFrame = frame

        view.clipsToBounds = true

        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration) {
            view.layer.cornerRadius = 18
            view.frame = finalFrame
        }
    }
}
