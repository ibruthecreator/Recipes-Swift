//
//  NibLoadable.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-15.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

protocol NibLoadable where Self: UIView {

    /// Setup this view with nib:
    /// 1. Load content view from nib (with the class name)
    /// 2. Set owner to self
    /// 3. Add it as a subview and fill edges with AutoLayout
    func fromNib() -> UIView?
}

extension NibLoadable {
    @discardableResult
    func fromNib() -> UIView? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {    // 3
            // xib not loaded, or its top view is of the wrong type
            
            print("error")
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.edges(to: self)
        return contentView
    }
}
