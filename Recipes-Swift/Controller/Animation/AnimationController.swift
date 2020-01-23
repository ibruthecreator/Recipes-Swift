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
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
        }
        
        switch animationType {
            case .present:
                toViewController.view.alpha = 0.0
                transitionContext.containerView.addSubview(toViewController.view)
                presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
                
            case .dismiss:
                // Need to add both otherwise the background will be black until the animation ends
                transitionContext.containerView.addSubview(toViewController.view)
                transitionContext.containerView.addSubview(fromViewController.view)
                dismissAnimation(with: transitionContext, viewToAnimate: fromViewController.view)
        }
    }
    
    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate view: UIView) {
        let originalFrame = view.frame  // Target's original frame in the "from" view controller, which is essentially full screen
        let originalBounds = view.bounds // VC's bounds in its own coordinate system
                
        guard let detailView = transitionContext.viewController(forKey: .to) as? RecipeDetailViewController else {
            transitionContext.completeTransition(false)
            return
        }
        
        // Get frame of selected recipe
        guard let frame = detailView.cellFrame else {
            transitionContext.completeTransition(false)
            return
        }
        
        view.frame = frame
        
        detailView.recipeCardContentViewLeadingAnchor.isActive = false
        detailView.recipeCardContentViewTrailingAnchor.isActive = false
        detailView.recipeCardContentViewWidthAnchor.constant = frame.width
        detailView.recipeCardContentViewHeightConstraint.constant = frame.height
        detailView.recipeCardContentView.fixLabelWidth(width: frame.width - (13*2))
        
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        
        view.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)   // Matches current state of cell (highlighted)
        view.alpha = 1.0   // Only once transformation is complete in order to match the cell, do we make the view visible
        
        // Flush changes
        detailView.recipeCardContentView.layoutIfNeeded()
        view.layoutIfNeeded()
        view.layoutSubviews()
                
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            // Go up and bounce "outwards"
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
                view.transform = CGAffineTransform(translationX: 0, y: -150)    // For some reason translation transform didn't work, so updating the frame is the way to go

                view.layoutIfNeeded()
            }
            
            // Grow out
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.9) {
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
    
    func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate view: UIView) {
        view.clipsToBounds = true
        
        guard let detailView = transitionContext.viewController(forKey: .from) as? RecipeDetailViewController else {
            transitionContext.completeTransition(false)
            return
        }
       
        // Get frame of selected recipe
        guard let frame = detailView.cellFrame else {
            transitionContext.completeTransition(false)
            return
        }
        
        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.5, options: [], animations: {
            // Scroll to top incase the user scrolls down a bit while in the detail view
            detailView.scrollView.showsVerticalScrollIndicator = false
            detailView.scrollView.setContentOffset(CGPoint(x: 0, y: -detailView.scrollView.contentInset.top), animated: true)
            
            view.layer.cornerRadius = 18
            view.frame = frame
             
            detailView.recipeCardContentViewWidthAnchor.constant = frame.width
            detailView.recipeCardContentViewHeightConstraint.constant = frame.height
            detailView.closeButton.alpha = 0.0
            
            detailView.recipeCardContentView.layoutIfNeeded()
            detailView.view.layoutIfNeeded()
        }) { (completed) in
            transitionContext.completeTransition(true)
        }
    }
}
