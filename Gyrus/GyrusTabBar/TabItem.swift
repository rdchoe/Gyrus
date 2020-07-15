//
//  TabItem.swift
//  Gyrus
//
//  Created by Robert Choe on 5/29/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

enum TabItem: String, CaseIterable {
    case alarm = "alarm"
    case create = "create"
    case dreams = "dreams"
    
    var viewController: UIViewController {
        switch self {
        case .alarm:
            return GyrusCreateAlarmPageViewController()
        case .create:
            return GyrusCreateDreamPageViewController()
        case .dreams:
            let navController = UINavigationController()
            navController.navigationBar.makeTransparent()
            navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.colors.white, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.h6)]
            navController.navigationBar.prefersLargeTitles = true
            navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.colors.white, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.h4)]
            navController.viewControllers = [GyrusAllLogsPageViewController()]
            return navController
        }
    }
    
    var icon: UIImage {
        let font = UIFont.systemFont(ofSize: 24)
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        switch self {
        case .alarm:
            return UIImage(systemName: "alarm", withConfiguration: configuration)!
        case .create:
            return #imageLiteral(resourceName: "create")
        case .dreams:
            return UIImage(systemName: "list.bullet", withConfiguration: configuration)!
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
