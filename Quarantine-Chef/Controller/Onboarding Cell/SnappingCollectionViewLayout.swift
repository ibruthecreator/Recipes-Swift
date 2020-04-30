//
//  SnappingCollectionViewLayout.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2020-01-01.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

// Open source code provided by Mark Bourke on Stack Overflow
// The purpose of this Collection View Layout is to make the onboarding collection view feel like an onboarding.
// Instead of being able to slide to any position in the collection view, including in between cells, and stopping
// This class forces a cell to be in full view at all time, and snaps to the nearest one
class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
        
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
