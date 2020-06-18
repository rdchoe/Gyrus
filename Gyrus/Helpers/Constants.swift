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
        static let futura_bold = "futura-bold"
        static let futura_italic = "Futura-MediumItalic"
        static let futura_condensed = "futura-condensedMedium"
        
        /// Font Sizes
        static let h1: CGFloat = 96.0
        static let h2: CGFloat = 60.0
        static let h3: CGFloat = 48.0
        static let h4: CGFloat = 34.0
        static let h5: CGFloat = 24.0
        static let h6: CGFloat = 20.0
        
        static let subtitle: CGFloat = 11.0
        static let body: CGFloat = 14.0
        static let tabBarSize: CGFloat = 10.0
        
        static let timePickerFontSize: CGFloat = 28.0
    }
    
    // MARK: Spacing
    struct spacing {
        static let standard: CGFloat = 8.0
    }

    // MARK: TabBar
    struct tabbar {
        static let tabbarRadius: CGFloat = 50.0
        static let tabbarLineWidth: CGFloat = 2.0
        static let tabbbarHeight: CGFloat = 67.0
    }
    
    struct dreamLogPage {
        static let categoryHeaderText: String = "Categories"
        static let placeholderText: String = "Type your dream here"
    }
    
    // MARK: Colors
    struct colors {
        static let gray: UIColor = #colorLiteral(red: 0.4909371734, green: 0.5244275331, blue: 0.5922471881, alpha: 1)
        static let blue: UIColor = #colorLiteral(red: 0.1467327774, green: 0.2175300121, blue: 0.3313943744, alpha: 1)
        static let textBlue: UIColor = #colorLiteral(red: 0.3482666612, green: 0.5096385479, blue: 0.7128044963, alpha: 1)
        static let buttonColor: UIColor = #colorLiteral(red: 0.2110268772, green: 0.2574242651, blue: 0.3377935886, alpha: 1)
        static let whiteTextColor: UIColor = #colorLiteral(red: 0.9679533839, green: 0.9687924981, blue: 0.9517564178, alpha: 1)
        static let grayBlue: UIColor = #colorLiteral(red: 0.2110268772, green: 0.2574242651, blue: 0.3377935886, alpha: 1)
        static let lightBlue: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
        static let white: UIColor = #colorLiteral(red: 0.9679533839, green: 0.9687924981, blue: 0.9517564178, alpha: 1)
        static let activeColor: UIColor = #colorLiteral(red: 0.4707381129, green: 0.6321940422, blue: 0.7315576077, alpha: 1)
        static let inactiveColor: UIColor = #colorLiteral(red: 0.2155992985, green: 0.242302984, blue: 0.2931298018, alpha: 1)
    }
    
    struct category {
        static let fontSize: CGFloat = 18.0
        static let cellHeight: CGFloat = 29.0
        static let activeColor: UIColor = #colorLiteral(red: 0.4707381129, green: 0.6321940422, blue: 0.7315576077, alpha: 1)
        static let inactiveColor: UIColor = #colorLiteral(red: 0.2155992985, green: 0.242302984, blue: 0.2931298018, alpha: 1)
        static let activeBorderColor: UIColor = #colorLiteral(red: 0.9679533839, green: 0.9687924981, blue: 0.9517564178, alpha: 1)
        static let inactiveBorderColor: UIColor = #colorLiteral(red: 0.1141634211, green: 0.1520627439, blue: 0.1904778481, alpha: 1)
    }
    
    struct categoryBottomSheet {
        static let inactiveColor: UIColor = #colorLiteral(red: 0.2272591144, green: 0.2656765435, blue: 0.3138055371, alpha: 1)
        static let activeColor: UIColor = #colorLiteral(red: 0.4707381129, green: 0.6321940422, blue: 0.7315576077, alpha: 1)
        static let nameFieldBackgroundColor: UIColor = #colorLiteral(red: 0.1194898859, green: 0.1329186261, blue: 0.1583568752, alpha: 1)
        static let borderColor: UIColor = #colorLiteral(red: 0.4432456493, green: 0.4431354702, blue: 0.447265625, alpha: 1)
        static let backgroundColor: UIColor = #colorLiteral(red: 0.123877801, green: 0.1445729733, blue: 0.1701545119, alpha: 1)
        static let emojiPickerBackgroundColor: UIColor = #colorLiteral(red: 0.1780658364, green: 0.1917771101, blue: 0.213049531, alpha: 1)
    }
}

enum PageState: CaseIterable {
    case selected, notSelected
}
