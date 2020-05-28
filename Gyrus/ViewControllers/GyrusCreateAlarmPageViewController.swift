//
//  GyrusCreateAlarmPageViewController.swift
//  Gyrus
//
//  Created by Robert Choe on 5/28/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

class GyrusCreateAlarmPageViewController: UIViewController {
    
    private let timePickerView: GyrusTimePicker = GyrusTimePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController() {
        self.view.setGradientBackground(colorOne: UIColor(red: 0.1101342663, green: 0.1352458894, blue: 0.2771074176, alpha: 1), colorTwo: UIColor(red: 0.2169839442, green: 0.342487067, blue: 0.4491402507, alpha: 1))
        view.addSubview(timePickerView)
        layoutConstraints()
    }
    
    private func layoutConstraints() {
        let views : [String:Any] = ["timePickerView" : self.timePickerView]
        
        [
            "H:[timePickerView(240)]",
            "V:[timePickerView(240)]"
        ].forEach{NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: nil, views: views))}
        self.timePickerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.timePickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}
