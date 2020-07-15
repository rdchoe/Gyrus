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
                |--contentWrapperView-----------------|
                |            |-----------------------|               |
                |            |TimePicker          |               |
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
    
    private let alarmLabel: UILabel = {
        let alarmLabel = UILabel()
        alarmLabel.translatesAutoresizingMaskIntoConstraints = false
        alarmLabel.textColor = Constants.colors.whiteTextColor
        alarmLabel.text = ""
        alarmLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.body)
        alarmLabel.textAlignment = .center

        return alarmLabel
    }()
    
    private let separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = Constants.colors.gray
        separator.alpha = 0
        return separator
    }()
    
    private let countdownTimerView: GyrusCountdownTimerView = {
        let countdownTimerView = GyrusCountdownTimerView()
        countdownTimerView.alpha = 0
        return countdownTimerView
    }()
    
    fileprivate let timeArcView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.alpha = 0
        return view
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let dateFormat = "'Waking up at' h:mm a"
        
        dateFormatter.dateFormat = dateFormat
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter
    }()
    
    private let timeArcImageView: UIImageView = {
        let iv = UIImageView()
        let configuration = UIImage.SymbolConfiguration(scale: .small)
        iv.image = UIImage(systemName: "moon.fill")
        iv.tintColor = .white
        return iv
    }()

    /// The state of the page that toggles when the main event button is clicked (each page should have this to determine the button functionality and title)
    private var pageState: PageState = .notSelected
    
    private var contentWrapperViewTopConstraint: NSLayoutConstraint!
    private var separatorLeadingConstraint: NSLayoutConstraint!
    private var separatorTrailingConstraint: NSLayoutConstraint!
    private var timeArcIsAnimating: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.largeTitleDisplayMode = .never
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarSetup()
        
    }
    
    private func setupViewController() {
        timePickerView.delegate = self
        countdownTimerView.delegate = self
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = true
        self.view.setGradientBackground(colorOne: #colorLiteral(red: 0.08831106871, green: 0.09370639175, blue: 0.1314730048, alpha: 1), colorTwo: #colorLiteral(red: 0.09751460701, green: 0.1287023127, blue: 0.1586345732, alpha: 1))
        view.addSubview(contentWrapperView)
        contentWrapperView.addSubview(timePickerView)
        contentWrapperView.addSubview(alarmLabel)
        contentWrapperView.addSubview(separator)
        contentWrapperView.addSubview(countdownTimerView)
        
        view.addSubview(timeArcView)
        
        // set delegate for tab bar to self to handle main event button functionality
        if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
            gyrusTabBarController.gyrusTabBar.delegate = self
        }
        layoutConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        //self.timeDidChange()
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
        
        contentWrapperViewTopConstraint = contentWrapperView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (self.view.frame.height / 3))
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

            self.alarmLabel.topAnchor.constraint(equalTo: self.timePickerView.bottomAnchor, constant: Constants.spacing.standard),
            self.alarmLabel.centerXAnchor.constraint(equalTo: self.timePickerView.centerXAnchor),
            self.alarmLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.alarmLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            self.separator.topAnchor.constraint(equalTo: self.alarmLabel.bottomAnchor, constant: 8),
            
            //self.countdownTimerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            //self.countdownTimerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.countdownTimerView.topAnchor.constraint(equalTo: self.separator.bottomAnchor),
            self.countdownTimerView.centerXAnchor.constraint(equalTo: self.timePickerView.centerXAnchor),
            self.countdownTimerView.widthAnchor.constraint(equalToConstant: 300),
            timeArcView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            timeArcView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -16),
            timeArcView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16),
            timeArcView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5, constant: 32)
            
        ])
    }
    
    private func tabBarSetup() {
        if let gyrusTabBarController = self.tabBarController as? GyrusTabBarController {
            gyrusTabBarController.gyrusTabBar.delegate = self
            switch self.pageState {
            case .selected:
                gyrusTabBarController.gyrusTabBar.mainEventButton.setTitle("Stop", for: .normal)
            case .notSelected:
                gyrusTabBarController.gyrusTabBar.mainEventButton.setTitle("Start", for: .normal)
            }
            gyrusTabBarController.gyrusTabBar.mainEventButton.titleLabel?.font = UIFont(name: Constants.font.futura, size: Constants.font.h5)
        }
    }

    //MARK: UITextField Handler
    @objc private func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}


// MARK: Gyrus Tab Bar Delegate-
extension GyrusCreateAlarmPageViewController: GyrusTabBarDelegate {
    func mainEventButtonClicked(button: UIButton) {
        // This function toggles the page state (asycnhronous reason)
        animateScreen(button: button)
        // Turning an alarm on if button is selected
        
        switch self.pageState {
        case .notSelected: // Page is not currently selected, and user pressed button | turning ON alarm
            guard let timeUntilAlarm = self.timePickerView.getSelectedTime() else {
                return
            }
            let alarm: Alarm = AppDelegate.appCoreDateManager.addAlarm(time: timeUntilAlarm, name: "alarm")
            
            PushNotificationManager.createLocalNotification(alarm: alarm)
            
            AppDelegate.GyrusAudioPlayer.play(atTime: AppDelegate.GyrusAudioPlayer.deviceCurrentTime + alarm.time!.timeIntervalSinceNow)
            print("time: \(AppDelegate.GyrusAudioPlayer.deviceCurrentTime + alarm.time!.timeIntervalSinceNow)")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alarm.time!.timeIntervalSinceNow, execute: {
                MPVolumeView.setVolume(1.0)
            })
            button.setTitle("Stop", for: .normal)

        case .selected: // Page is currently selected, and user pressed button | turning OFF alarm
            // Stop the audio player
            AppDelegate.GyrusAudioPlayer.stop()
            // delete all pending alarms
            AppDelegate.appCoreDateManager.deleteAllAlarms()
            // remove all pending local notifications
            PushNotificationManager.removeAllPendingAlarmNotification()
            button.setTitle("Start", for: .normal)
        }
    }
    
    private func animateScreen(button: UIButton) {
        button.isUserInteractionEnabled = false
        self.alarmLabel.isUserInteractionEnabled = false
        
        let contentWrapperViewFrame = self.contentWrapperView.frame
        let distanceToTravel = self.alarmLabel.frame.origin.y - self.timePickerView.frame.origin.y
        self.createTimeArc()
        
        if !self.timePickerView.currentlySelectingTime {
            switch self.pageState {
            case .notSelected: // | Turning ON the alarm
                guard let selectedTime = self.timePickerView.getSelectedTime() else { return }
                let timeTillAlarm = selectedTime.timeIntervalSinceNow
                self.countdownTimerView.startCountdown(time: timeTillAlarm)
                // Animate the time picker expansion, THEN (on completion) do other animations
                UIView.animate(withDuration: 0.75, delay: 0.0, options: .curveEaseInOut, animations: {
                    // 1
                    self.timePickerView.animateSelectionView(pageState: self.pageState)
                    // CHANGE THE ALARM LABEL
                    self.alarmLabel.alpha = 0
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
                            self.separator.alpha = 1
                            self.separatorLeadingConstraint.constant = -72
                            self.separatorTrailingConstraint.constant = 72
                            self.separator.backgroundColor = Constants.colors.whiteTextColor
                            self.countdownTimerView.alpha = 1
                            
                            // ADD THE TIME ARC
                            self.timeArcView.alpha = 1
                            // layoutifneeded necesary for the constraint constant changes to animate
                            
                            print("changing alarm label text to date")
                            
                            self.alarmLabel.text = self.dateFormatter.string(from: selectedTime)
                            self.alarmLabel.font = UIFont(name: Constants.font.futura, size: 28.0)
                            self.alarmLabel.alpha = 1
                            self.view.layoutIfNeeded()
                        })
                        self.pageState = .selected
                        button.isUserInteractionEnabled = true
                    })
                })
            case .selected: // animating back to in-active state | Turning OFF the alarm
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    // 1
                    self.countdownTimerView.alpha = 0
                    self.separatorLeadingConstraint.constant = 0
                    self.separatorTrailingConstraint.constant = 0
                    self.separator.backgroundColor = Constants.colors.gray
                    // layoutifneeded necesary for the constraint constant changes to animate
                    
                    // MAKE ALARM LABEL INVISIBLE
                    self.alarmLabel.alpha = 0
                    self.timeArcView.alpha = 0
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    UIView.animate(withDuration: 0.75, delay: 0.25, options: .curveEaseInOut,animations: {
                        // 2
                        self.separator.alpha = 0
                        self.contentWrapperViewTopConstraint.constant += distanceToTravel
                        self.timePickerView.alpha = 1
                        self.contentWrapperView.frame = contentWrapperViewFrame
                        self.countdownTimerView.alpha = 0
                        self.countdownTimerView.stopCountdown()
                        // CHANGE ALARM LABEL BACK
                        let time = NSInteger(self.timePickerView.getSelectedTime()!.timeIntervalSinceNow)
                        self.alarmLabel.text = String(self.stringFromTimeinSeconds(time: time))
                        self.alarmLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.body)
                        self.alarmLabel.alpha = 1
                        // layoutifneeded necesary for the constraint constant changes to animate
                        self.view.layoutIfNeeded()
                    }, completion: {_ in
                        // 3
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut,animations: {
                            self.timePickerView.animateSelectionView(pageState: self.pageState)
                        }, completion: { _ in
                            // 4
                            button.isUserInteractionEnabled = true
                            self.alarmLabel.isUserInteractionEnabled = true
                            self.pageState = .notSelected
                        })
                    })
                })
            }
        } else { // The user is in the middle of interacting with the time picker
            button.isUserInteractionEnabled = true // interaction should be set back to true
        }
    }
}

extension GyrusCreateAlarmPageViewController: timePickerDelegate {
    func timeDidChange() {
        // Don't want this being called while animating
        if self.pageState == .notSelected {
            let time = NSInteger(self.timePickerView.getSelectedTime()!.timeIntervalSinceNow)
            self.alarmLabel.text = String(stringFromTimeinSeconds(time: time))
        }
    }
   
    fileprivate func stringFromTimeinSeconds (time: NSInteger) -> NSString {
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        var hoursString = "hours"
        if hours == 1 {
            hoursString = "hour"
        }
        
        if hours == 0 {
            if minutes == 0 {
                return NSString(format: "Wake up like right now?",minutes)
            } else if minutes == 1 {
                return NSString(format: "Wake up in %0.1d minute",minutes)
            } else {
                return NSString(format: "Wake up in %0.1d minutes",minutes)
            }
        } else {
            if minutes == 0 {
                return NSString(format: "Wake up in %0.1d %@",hours,hoursString)
            } else if minutes == 1 {
                return NSString(format: "Wake up in %0.1d %@ and %0.1d minute",hours,hoursString,minutes)
            } else {
                return NSString(format: "Wake up in %0.1d %@ and %0.1d minutes",hours,hoursString,minutes)
            }
        }
    }
    
    fileprivate func createTimeArc() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.path = createArcPath()
        self.timeArcView.layer.addSublayer(shapeLayer)
        timeArcView.addSubview(timeArcImageView)
        
    }
    
    fileprivate func createArcPath() -> CGPath {
        let radius: CGFloat = self.timeArcView.frame.height
        let path = UIBezierPath()
        let centerWidth = self.timeArcView.frame.width / 2
        let startingPointY = self.timeArcView.frame.height
        path.move(to: CGPoint(x: 0, y: startingPointY))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: startingPointY) , radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle:CGFloat(0).degreesToRadians, clockwise: true)
        
        return path.cgPath
    }
}

extension GyrusCreateAlarmPageViewController: coundownTimerDelegate {
    func didTick(time: NSInteger) {
        let startingTime = self.countdownTimerView.startingTime
        let degree = CGFloat(((135*time)/startingTime)).degreesToRadians
        let radius: CGFloat = self.timeArcView.frame.height
        let cx = self.timeArcView.frame.width / 2
        let cy = self.timeArcView.frame.height
        let x =  cx + radius * cos(degree)
        let y =  cy - radius * sin(degree)
        if timeArcIsAnimating {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
                self.timeArcImageView.frame = CGRect(x: x - 20, y: y - 20, width: 40, height: 40)
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.timeArcImageView.frame = CGRect(x: x - 20, y: y - 20, width: 40, height: 40)
            self.view.layoutIfNeeded()
            timeArcIsAnimating = true
        }
    }
    
    
}
