//
//  GyrusCreateAlarmPageViewController.swift
//  Gyrus
//
//  Created by Robert Choe on 5/28/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

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
        alarmLabel.placeholder = "Alarm"
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

    var contentWrapperViewTopConstraint: NSLayoutConstraint!
    var separatorLeadingConstraint: NSLayoutConstraint!
    var separatorTrailingConstraint: NSLayoutConstraint!
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
        
        contentWrapperViewTopConstraint = contentWrapperView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (self.view.frame.height / 4))
        contentWrapperViewTopConstraint.isActive = true
        
        separatorLeadingConstraint = self.separator.leadingAnchor.constraint(equalTo: self.timePickerView.leadingAnchor)
        separatorLeadingConstraint.isActive = true
        separatorTrailingConstraint = self.separator.trailingAnchor.constraint(equalTo: self.timePickerView.trailingAnchor)
        separatorTrailingConstraint.isActive = true
        NSLayoutConstraint.activate([
            contentWrapperView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            contentWrapperView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            contentWrapperView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            self.timePickerView.topAnchor.constraint(equalTo: contentWrapperView.topAnchor),
            self.timePickerView.centerXAnchor.constraint(equalTo: contentWrapperView.centerXAnchor),

            self.alarmLabel.leadingAnchor.constraint(equalTo: self.timePickerView.leadingAnchor),
            self.alarmLabel.trailingAnchor.constraint(equalTo: self.timePickerView.trailingAnchor),
            self.alarmLabel.topAnchor.constraint(equalTo: self.timePickerView.bottomAnchor, constant: Constants.spacing.standard),
        
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
        animateScreen(button: button)
        // Turning an alarm on if button is selected
        if button.isSelected {
            guard let timeUntilAlarm = self.timePickerView.getSelectedTime() else {
                return
            }
            let alarm: Alarm = AppDelegate.appCoreDateManager.addAlarm(time: timeUntilAlarm, name: self.alarmLabel.text ?? self.alarmLabel.placeholder!)
            
            PushNotificationManager.createLocalNotification(alarm: alarm)
           
            let alarmSound = Bundle.main.path(forResource: "boniver", ofType: "mp3")
            do {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.duckOthers, .defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(true)
                UIApplication.shared.beginReceivingRemoteControlEvents()
                AppDelegate.GyrusAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: alarmSound!))
                print(AppDelegate.GyrusAudioPlayer.deviceCurrentTime)
                AppDelegate.GyrusAudioPlayer.play(atTime: AppDelegate.GyrusAudioPlayer.deviceCurrentTime + alarm.time!.timeIntervalSinceNow)
                print("time: \(AppDelegate.GyrusAudioPlayer.deviceCurrentTime + alarm.time!.timeIntervalSinceNow)")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alarm.time!.timeIntervalSinceNow, execute: {
                    MPVolumeView.setVolume(1.0)
                })

            } catch {
               print(error)
            }
        } else { // deactivating an alarm
            // Stop the audio player
            AppDelegate.GyrusAudioPlayer.stop()
            // delete all pending alarms
            AppDelegate.appCoreDateManager.deleteAllAlarms()
        }
    }
    
    private func animateScreen(button: UIButton) {
        button.isUserInteractionEnabled = false
        self.alarmLabel.isUserInteractionEnabled = false
        
        let contentWrapperViewFrame = self.contentWrapperView.frame
        let distanceToTravel = self.alarmLabel.frame.origin.y - self.timePickerView.frame.origin.y
        
        
        if !self.timePickerView.currentlySelectingTime {
            if button.isSelected { // | Turning ON the alarm
                guard let timeTillAlarm = self.timePickerView.getSelectedTime()?.timeIntervalSinceNow else {
                    return
                }
                self.countdownTimerView.startCountdown(time: timeTillAlarm)
                // Animate the time picker expansion, THEN (on completion) do other animations
                UIView.animate(withDuration: 0.75, delay: 0.25, options: .curveEaseInOut, animations: {
                    // 1
                    self.timePickerView.animateSelectionView(mainEventButton: button)
                }, completion: { _ in
                    // 2
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.contentWrapperViewTopConstraint.constant -= distanceToTravel
                        self.timePickerView.alpha = 0
                        self.contentWrapperView.frame = contentWrapperViewFrame
                        // layoutifneeded necesary for the constraint constant changes to animate
                        self.view.layoutIfNeeded()
                    }, completion: { _ in
                        // 3
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                            self.separatorLeadingConstraint.constant = -24
                            self.separatorTrailingConstraint.constant = 24
                            self.separator.backgroundColor = Constants.colors.whiteTextColor
                            self.countdownTimerView.alpha = 1
                            // layoutifneeded necesary for the constraint constant changes to animate
                            self.view.layoutIfNeeded()
                        })
                        button.isUserInteractionEnabled = true
                    })
                })
            } else { // animating back to in-active state | Turning OFF the alarm
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    // 1
                    self.countdownTimerView.alpha = 0
                    self.separatorLeadingConstraint.constant = 0
                    self.separatorTrailingConstraint.constant = 0
                    self.separator.backgroundColor = Constants.colors.gray
                    // layoutifneeded necesary for the constraint constant changes to animate
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    UIView.animate(withDuration: 0.75, delay: 0.25, options: .curveEaseInOut,animations: {
                        // 2
                        self.contentWrapperViewTopConstraint.constant += distanceToTravel
                        self.timePickerView.alpha = 1
                        self.contentWrapperView.frame = contentWrapperViewFrame
                        self.countdownTimerView.alpha = 0
                        self.countdownTimerView.stopCountdown()
                        // layoutifneeded necesary for the constraint constant changes to animate
                        self.view.layoutIfNeeded()
                    }, completion: {_ in
                        // 3
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut,animations: {
                            self.timePickerView.animateSelectionView(mainEventButton: button)
                        }, completion: { _ in
                            // 4
                            button.isUserInteractionEnabled = true
                            self.alarmLabel.isUserInteractionEnabled = true
                        })
                    })
                })
                
            }
        } else { // The user is in the middle of interacting with the time picker
            button.isUserInteractionEnabled = true // interaction should be set back to true
            button.isSelected = false // button selection should be undone
        }
    }
}
