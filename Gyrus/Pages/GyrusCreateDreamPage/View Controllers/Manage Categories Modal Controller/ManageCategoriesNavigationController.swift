//
//  ManageCategoriesNavigationController.swift
//  Gyrus
//
//  Created by Robert Choe on 6/30/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

class ManageCategoriesNavigationController: UINavigationController {
    
    fileprivate var relatedCategories: [Category] = []
    fileprivate var remainingCategories: [Category] = []
    fileprivate var mangageCategoiresDelegate: manageCategoriesDelegate!
    
    init(relatedCategories: [Category], remainingCategories: [Category], delegate: manageCategoriesDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.relatedCategories = relatedCategories
        self.remainingCategories = remainingCategories
        self.mangageCategoiresDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground(colorOne: #colorLiteral(red: 0.08831106871, green: 0.09370639175, blue: 0.1314730048, alpha: 1), colorTwo: #colorLiteral(red: 0.09751460701, green: 0.1287023127, blue: 0.1586345732, alpha: 1))
        self.navigationBar.makeTransparent()
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.colors.white, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.h6)]
        
    
        self.viewControllers = [ManageCategoriesViewController(relatedCategories: relatedCategories, remainingCategories: remainingCategories, delegate: self.mangageCategoiresDelegate)]
    }
}
