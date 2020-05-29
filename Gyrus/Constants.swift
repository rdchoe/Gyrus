//
//  Constants.swift
//  Gyrus
//
//  Created by Robert Choe on 5/28/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//
import Foundation
import UIKit
struct Constants {
    //MARK: Font
    struct font {
        static let futura = "futura"
        
        /// Font Sizes
        static let h1: CGFloat = 96.0
        static let h2: CGFloat = 60.0
        static let h3: CGFloat = 48.0
        static let h4: CGFloat = 34.0
        static let h5: CGFloat = 24.0
        static let h6: CGFloat = 20.0
        
        static let subtitle: CGFloat = 1.0
        static let body: CGFloat = 14.0
    }
    
    // MARK: Spacing
    struct spacing {
        static let standard: CGFloat = 8.0
    }

    // MARK: TabBar
    struct tabbar {
        static let tabbarRadius: CGFloat = 50.0
        static let tabbarLineWidth: CGFloat = 2.0
    }
    
    // MARK: Colors
    struct colors {
        static let gray: UIColor = #colorLiteral(red: 0.4909371734, green: 0.5244275331, blue: 0.5922471881, alpha: 1)
        static let blue: UIColor = #colorLiteral(red: 0.1467327774, green: 0.2175300121, blue: 0.3313943744, alpha: 1)
    }
}
