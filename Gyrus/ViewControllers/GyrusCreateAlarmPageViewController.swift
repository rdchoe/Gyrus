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
    private let alarmLabel: UITextField = {
        let alarmLabel = UITextField()
        alarmLabel.translatesAutoresizingMaskIntoConstraints = false
        alarmLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        alarmLabel.text = "Alarm"
        alarmLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.h4)
        alarmLabel.textAlignment = .center
        alarmLabel.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))

        return alarmLabel
    }()
    private let separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = Constants.colors.gray
        return separator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController() {
        self.view.setGradientBackground(colorOne: UIColor(red: 0.1101342663, green: 0.1352458894, blue: 0.2771074176, alpha: 1), colorTwo: UIColor(red: 0.2169839442, green: 0.342487067, blue: 0.4491402507, alpha: 1))
        view.addSubview(alarmLabel)
        view.addSubview(separator)
        view.addSubview(timePickerView)
        layoutConstraints()
    }
    
    private func layoutConstraints() {
        // Views that require mannual declaration of height/width
        let views : [String:Any] = ["timePickerView" : self.timePickerView, "separator" : self.separator]
        
        [
            "H:[timePickerView(210)]",
            "V:[timePickerView(210)]",
            "V:[separator(2)]"
        ].forEach{NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: nil, views: views))}
        
        /// This constraint offsets the center of the time picker view by a quarter of the center of the page view
        let constraint = NSLayoutConstraint(item: timePickerView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.75, constant: 0)
        self.view.addConstraint(constraint)
        self.timePickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        self.alarmLabel.leadingAnchor.constraint(equalTo: self.timePickerView.leadingAnchor).isActive = true
        self.alarmLabel.trailingAnchor.constraint(equalTo: self.timePickerView.trailingAnchor).isActive = true
        self.alarmLabel.topAnchor.constraint(equalTo: self.timePickerView.bottomAnchor, constant: Constants.spacing.standard).isActive = true
        
        self.separator.leadingAnchor.constraint(equalTo: self.timePickerView.leadingAnchor).isActive = true
        self.separator.trailingAnchor.constraint(equalTo: self.timePickerView.trailingAnchor).isActive = true
        self.separator.topAnchor.constraint(equalTo: self.alarmLabel.bottomAnchor).isActive = true
    }

    //MARK: UITextField Handler
    @objc private func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}
