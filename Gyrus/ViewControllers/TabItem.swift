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
    
    var viewController: UIViewController {
        switch self {
        case .alarm:
            return GyrusCreateAlarmPageViewController()
        }
    }
}
