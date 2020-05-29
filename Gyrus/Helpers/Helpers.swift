//
//  Helpers.swift
//  Gyrus
//
//  Created by Robert Choe on 5/29/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

class Helpers: NSObject {
    func getSafeAreaTop()  -> CGFloat {
        return UIView().safeAreaTop
    }
    
    func getSafeAreaBottom() -> CGFloat {
        return UIView().safeAreaBottom
    }
}
