//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Quarantine-Chef
//
//  Created by Mohammed Ibrahim on 2020-05-03.
//  Copyright © 2020 Mohammed Ibrahim. All rights reserved.
//

import UIKit

/// Open source code from https://stackoverflow.com/questions/22539979/left-align-cells-in-uicollectionview
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
