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
    
    /**
                |--contentWrapperView(stackview)--|
                |            |-----------------------|               |
                |            |TimePicker          |
                |            |-----------------------|               |
                |                                                        |
                |            |-----------------------|               |
                |            |Alarm Label|       |              |
                |            |-----------------------|              |
                |                        |                              |
                |            -----separator-----                |
                |            |-----------------------|              |
                |            |countdown_timer|              |
                |            |-----------------------|              |
                |                        |                              |
                |            |-----------------------|              |
                |            |fun_fact|              |              |
                |            |-----------------------|              |
                |----------------------------------------------|
     */
    
    /// The vertical stack view container all the visual componets of the page
    private let contentWrapperView: UIView = {
        let contentWrapperView = UIView()
        contentWrapperView.translatesAutoresizingMaskIntoConstraints = false
        contentWrapperView.backgroundColor = UIColor.clear
        return contentWrapperView
    }()
    
    private let timePickerView: GyrusTimePicker = GyrusTimePicker()
    
    private let alarmLabel: UITextField = {
        let alarmLabel = UITextField()
        alarmLabel.translatesAutoresizingMaskIntoConstraints = false
        alarmLabel.textColor = Constants.colors.whiteTextColor
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
    
    private let countdownTimerView: GyrusCountdownTimerView = {
        let countdownTimerView = GyrusCountdownTimerView()
        countdownTimerView.alpha = 0
        return countdownTimerView
    }()
    
    
    
    var timePickerCenterYConstraint: NSLayoutConstraint!
    var contentWrapperViewTopConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
            let sleepingIcon = UIImage(cgImage: #imageLiteral(resourceName: "napping").cgImage!, scale: #imageLiteral(resourceName: "napping").scale * -0.5, orientation:#imageLiteral(resourceName: "napping").imageOrientation)
            
            sleepingIcon.withTintColor(UIColor.white, renderingMode: .automatic)
            gyrusTabBarController.gyrusTabBar.mainEventButton.setImage(sleepingIcon, for: .normal)
        }
    }
    
    private func setupViewController() {
        self.view.setGradientBackground(colorOne: #colorLiteral(red: 0.08831106871, green: 0.09370639175, blue: 0.1314730048, alpha: 1), colorTwo: #colorLiteral(red: 0.09751460701, green: 0.1287023127, blue: 0.1586345732, alpha: 1))
        view.addSubview(contentWrapperView)
        contentWrapperView.addSubview(timePickerView)
        contentWrapperView.addSubview(alarmLabel)
        contentWrapperView.addSubview(separator)
        contentWrapperView.addSubview(countdownTimerView)
        
        
        // set delegate for tab bar to self to handle main event button functionality
        if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
            gyrusTabBarController.gyrusTabBar.delegate = self
        }
        
        layoutConstraints()
    }
    
    private func layoutConstraints() {
        // Views that require mannual declaration of height/width
        let views : [String:Any] = ["timePickerView" : self.timePickerView, "separator" : self.separator, "contentWrapperView": self.contentWrapperView, "countdownTimerView": self.countdownTimerView]
        
        [
            "H:[timePickerView(200)]",
            "V:[timePickerView(200)]",
            "V:[separator(2)]",
            "V:[countdownTimerView(100)]"
        ].forEach{NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: nil, views: views))}
        
        contentWrapperViewTopConstraint = contentWrapperView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (self.view.frame.height / 8))
        contentWrapperViewTopConstraint.isActive = true
        NSLayoutConstraint.activate([
            contentWrapperView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            contentWrapperView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            contentWrapperView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            self.timePickerView.topAnchor.constraint(equalTo: contentWrapperView.topAnchor),
            self.timePickerView.centerXAnchor.constraint(equalTo: contentWrapperView.centerXAnchor),

            self.alarmLabel.leadingAnchor.constraint(equalTo: self.timePickerView.leadingAnchor),
            self.alarmLabel.trailingAnchor.constraint(equalTo: self.timePickerView.trailingAnchor),
            self.alarmLabel.topAnchor.constraint(equalTo: self.timePickerView.bottomAnchor, constant: Constants.spacing.standard),
            
            self.separator.leadingAnchor.constraint(equalTo: self.timePickerView.leadingAnchor),
            self.separator.trailingAnchor.constraint(equalTo: self.timePickerView.trailingAnchor),
            self.separator.topAnchor.constraint(equalTo: self.alarmLabel.bottomAnchor),
            
            self.countdownTimerView.leadingAnchor.constraint(equalTo: self.timePickerView.leadingAnchor),
            self.countdownTimerView.trailingAnchor.constraint(equalTo: self.timePickerView.trailingAnchor),
            self.countdownTimerView.topAnchor.constraint(equalTo: self.separator.bottomAnchor)
            
        ])
    }

    //MARK: UITextField Handler
    @objc private func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}

extension GyrusCreateAlarmPageViewController: GyrusTabBarDelegate {
    func mainEventButtonClicked(button: UIButton) {
        
        button.isUserInteractionEnabled = false
        self.alarmLabel.isUserInteractionEnabled = false
        
        let contentWrapperViewFrame = self.contentWrapperView.frame
        let distanceToTravel = self.alarmLabel.frame.origin.y - self.timePickerView.frame.origin.y
        
        
        if !self.timePickerView.currentlySelectingTime {
            
            print("i am not currently selecting a time")
            if button.isSelected { // | Turning ON the alarm
                guard let timeTillAlarm = self.timePickerView.getSelectedTime()?.timeIntervalSinceNow else {
                    return
                }
                self.countdownTimerView.startCountdown(time: timeTillAlarm)
                UIView.animate(withDuration: 0.75, delay: 0.25, options: .curveEaseInOut, animations: {
                    self.timePickerView.animateSelectionView(mainEventButton: button)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.contentWrapperViewTopConstraint.constant -= distanceToTravel
                        self.timePickerView.alpha = 0
                        self.contentWrapperView.frame = contentWrapperViewFrame
                        
                        
                        self.view.layoutIfNeeded()
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                            self.countdownTimerView.alpha = 1
                        })
                        button.isUserInteractionEnabled = true
                    })
                })
            } else { // animating back to in-active state | Turning OFF the alarm
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.countdownTimerView.alpha = 0
                }, completion: { _ in
                    UIView.animate(withDuration: 0.75, delay: 0.25, options: .curveEaseInOut,animations: {
                        self.contentWrapperViewTopConstraint.constant += distanceToTravel
                        self.timePickerView.alpha = 1
                        self.contentWrapperView.frame = contentWrapperViewFrame
                        self.countdownTimerView.alpha = 0
                        self.countdownTimerView.stopCountdown()
                        self.view.layoutIfNeeded()
                    }, completion: {_ in
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut,animations: {
                            self.timePickerView.animateSelectionView(mainEventButton: button)
                        }, completion: { _ in
                            button.isUserInteractionEnabled = true
                            self.alarmLabel.isUserInteractionEnabled = true
                        })
                    })
                })
                
            }
        } else { // The user is in the middle of interacting with the time picker
            print("what the heck it says that i am currently selecting a time")
            button.isUserInteractionEnabled = true // interaction should be set back to true
            button.isSelected = false // button selection should be undone
        }
    }
}
