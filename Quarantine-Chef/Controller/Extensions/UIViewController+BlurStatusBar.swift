//
//  UIViewController+BlurStatusBar.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-17.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

extension UIViewController {
    // Adds a blurred status bar to a view controller
    // Helps with scroll views so that content does not overlap with elements in the status bar.
    func addBlurredStatusBar() {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        
        let statusBarView = UIView(frame: CGRect(x:0, y:0, width:view.frame.size.width, height: keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0))
                
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = statusBarView.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        statusBarView.addSubview(blurEffectView)
        view.addSubview(statusBarView)
    }
}
