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
            navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navController.navigationBar.shadowImage = UIImage()
            navController.navigationBar.isTranslucent = true
            navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.colors.white, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.h6)]
            navController.navigationBar.prefersLargeTitles = true
            navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.colors.white, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.h4)]
            navController.viewControllers = [GyrusAllLogsPageViewController()]
            return navController
        }
    }
    
    var icon: UIImage {
        switch self {
        case .alarm:
            return #imageLiteral(resourceName: "alarm")
        case .create:
            return #imageLiteral(resourceName: "create")
        case .dreams:
            return #imageLiteral(resourceName: "logs").imageWithColor(color: Constants.colors.white)
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
