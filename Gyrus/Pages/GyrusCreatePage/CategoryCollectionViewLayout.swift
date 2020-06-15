//
//  CategoryCollectionViewLayout.swift
//  Gyrus
//
//  Created by Robert Choe on 6/4/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

class CategoryCollectionViewLayout: UICollectionViewLayout {
    
    let CELL_HEIGHT = 30.0
    let CELL_WIDTH = 100.0
    var categories: [[Category]]! {
        didSet {
            measurementMatrix = [[],[],[]]
            for section in 0...categories.count - 1 {
                if categories[section].count > 0  {
                    for _ in 0...categories[section].count - 1 {
                        measurementMatrix[section].append(0.0)
                    }
                }
            }
        }
    }
    var measurementMatrix: [[Double]] = [[],[],[]]
    
    var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    override init() {
        super.init()
    }
    
    convenience init(categories: [[Category]]) {
        self.init()
        self.categories = categories
        print(categories.count)
        for section in 0...categories.count - 1 {
            if categories[section].count > 0  {
                for _ in 0...categories[section].count - 1 {
                    measurementMatrix[section].append(0.0)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    /**
     Cycles through our data source and calculates each cell's position within the collection and compiles attribute objects that will be
     provided to the collection view.
     
     Accomplishes the following:
     1. Generate UICollectionViewAttributeLayouts with each cell’s position and size.
     2. Calculate the correct contentSize for our collection view.
     */
    override func prepare() {
        guard let categoryCollectionView = self.collectionView else {
            return
        }
        var longestSection: Double = 0.0
        var longestHeight: Double = 0.0
        if categoryCollectionView.numberOfSections > 0 {
            for section in 0...collectionView!.numberOfSections - 1 {
                if categoryCollectionView.numberOfItems(inSection: section) > 0 {
                    for item in 0...collectionView!.numberOfItems(inSection: section) - 1 {
                        let cellIndex = IndexPath(item: item, section: section)
                        let name = categories[section][item].name! as NSString
                        let emoji = categories[section][item].emoji! as NSString

                        let categoryLabel = "\(emoji) \(name)" as NSString
                        let categorySize = categoryLabel.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: Constants.font.futura_condensed, size: Constants.category.fontSize)!])
                        let width = Double(categorySize.width) + 16
                        let height = Double(categorySize.height) + 8
                        if longestHeight != 0.0 {
                            longestHeight = height
                        }
                        var xPos: Double
                        var yPos: Double = Double(section) * (height + 8)
                        if item == 0 {
                            xPos = 16
                            self.measurementMatrix[section][item] = width + 8 + 16 // adding 8 for padding
                        } else {
                            xPos = self.measurementMatrix[section][item-1]
                            self.measurementMatrix[section][item] = self.measurementMatrix[section][item-1] + width + 8 // adding 8 for padding
                        }
                        
                        if self.measurementMatrix[section][item] >= longestSection {
                            longestSection = self.measurementMatrix[section][item]
                        }

                        var cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
                        cellAttributes.zIndex = 1
                        cellAttrsDictionary[cellIndex] = cellAttributes
                    }
                }
            }
        }
        self.contentSize = CGSize(width: longestSection, height: Double(categoryCollectionView.numberOfSections) * longestHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cellAttrsDictionary[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
 
}
