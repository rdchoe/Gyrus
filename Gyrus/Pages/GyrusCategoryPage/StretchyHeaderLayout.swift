//
//  StretchyHeaderLayout.swift
//  Gyrus
//
//  Created by Robert Choe on 6/25/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ (attr) in
            if attr.representedElementKind == UICollectionView.elementKindSectionHeader {
                guard let collectionView = collectionView else { return }
                if attr.indexPath.section == 0 {
                    let contentOffsetY = collectionView.contentOffset.y
                    let height = attr.frame.height - contentOffsetY
                    let width = collectionView.frame.width
                    attr.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
                } else if attr.indexPath.section == 1 {
                    
                    let translatedY = collectionView.convert(attr.frame.origin, to: nil).y
                    if translatedY <= 88 {
                        collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)[0].backgroundColor = Constants.colors.backgroundColorApprx
                        attr.frame = CGRect(x: 0, y: collectionView.contentOffset.y + 88, width: collectionView.frame.width, height: attr.frame.height)
                    } else {
                        if collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).count != 0 {
                            collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader)[0].backgroundColor = .clear
                        }
                    }
                }

            }
        })
        return layoutAttributes
    }
 
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
