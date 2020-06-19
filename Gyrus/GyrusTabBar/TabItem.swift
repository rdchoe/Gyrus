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
    case logs = "logs"
    
    var viewController: UIViewController {
        switch self {
        case .alarm:
            return GyrusCreateAlarmPageViewController()
        case .create:
            return GyrusCreateDreamPageViewController()
        case .logs:
            return GyrusAllLogsPageViewController()
        }
    }
    
    var icon: UIImage {
        switch self {
        case .alarm:
            return #imageLiteral(resourceName: "alarm")
        case .create:
            return #imageLiteral(resourceName: "create")
        case .logs:
            return #imageLiteral(resourceName: "logs").imageWithColor(color: Constants.colors.white)
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
