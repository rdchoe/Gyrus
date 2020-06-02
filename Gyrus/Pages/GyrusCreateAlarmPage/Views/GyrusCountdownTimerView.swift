//
//  GyrusCountdownTimer.swift
//  Gyrus
//
//  Created by Robert Choe on 6/1/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

class GyrusCountdownTimerView: UIView {
   
    /**
            |--containerStackView(horizontal)-|
            |                                                     |
            |   |----|     |----|   |----|  |----|   |----|   |
            |   | hr |    |  :  |   |min|  | :  |   |sec|  |
            |   |----|    |----|    |----|  |----|   |----|   |
            |                                                    |
            |--------------------------------------------|
    */
    /// The horizontal stackview containing the components of the count down timer
    private var containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .horizontal
        containerStackView.distribution = .equalSpacing
        return containerStackView
    }()
   
    /// Labels to represent time
    private var hourLabel: UILabel = {
        let hourLabel = UILabel()
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        hourLabel.font = UIFont(name: Constants.font.futura_bold, size: Constants.font.timePickerFontSize)
        hourLabel.textColor = Constants.colors.gray
        hourLabel.text = "00"
        return hourLabel
    }()
    
    private var semicolonLabelFirst: UILabel = {
        let semicolonLabel = UILabel()
        semicolonLabel.translatesAutoresizingMaskIntoConstraints = false
        semicolonLabel.font = UIFont(name: Constants.font.futura_bold, size: Constants.font.timePickerFontSize)
        semicolonLabel.textColor = Constants.colors.gray
        semicolonLabel.text = ":"
        return semicolonLabel
    }()
    
    private var minuteLabel: UILabel = {
        let minuteLabel = UILabel()
        minuteLabel.translatesAutoresizingMaskIntoConstraints = false
        minuteLabel.font = UIFont(name: Constants.font.futura_bold, size: Constants.font.timePickerFontSize)
        minuteLabel.textColor = Constants.colors.gray
        minuteLabel.text = "00"
        return minuteLabel
    }()
    
    private var semicolonLabelSecond: UILabel = {
        let semicolonLabel = UILabel()
        semicolonLabel.translatesAutoresizingMaskIntoConstraints = false
        semicolonLabel.font = UIFont(name: Constants.font.futura_bold, size: Constants.font.timePickerFontSize)
        semicolonLabel.textColor = Constants.colors.gray
        semicolonLabel.text = ":"
        return semicolonLabel
    }()
    
    private var secondsLabel: UILabel = {
        let secondsLabel = UILabel()
        secondsLabel.translatesAutoresizingMaskIntoConstraints = false
        secondsLabel.font = UIFont(name: Constants.font.futura_bold, size: Constants.font.timePickerFontSize)
        secondsLabel.textColor = Constants.colors.gray
        secondsLabel.text = "00"
        return secondsLabel
    }()
   
    /// Timer functionality
    /// Timer object that will handle executing a code block every second
    private var countTimer: Timer?
    /// A integer representing how many seconds are left in the timer
    private var counter = 0
    /// A boolean representing if the countdown can be started
    var timerActive: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(hourLabel)
        containerStackView.addArrangedSubview(semicolonLabelFirst)
        containerStackView.addArrangedSubview(minuteLabel)
        containerStackView.addArrangedSubview(semicolonLabelSecond)
        containerStackView.addArrangedSubview(secondsLabel)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerStackView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])

    }
    
    /**
     Starts the timer
     Parameters:
     - time: time until alarm needs to go off
     */
    func startCountdown(time: TimeInterval) {
        // If timer is already active, don't do anything
        if self.timerActive == true {
            return
        }
        // Activate timer
        self.timerActive = true
        // Set counter to the time interval representing time until alarm needs to go off
        self.counter = NSInteger(time)
        
        self.countTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.updateCounterLabels(stringTime: self.stringFromTimeinSeconds(time: self.counter))
            // If timer is done
            if self.counter == 0 {
                timer.invalidate()
            } else { // If the the timer is not done, do this each tick
                self.counter -= 1
            }
        })
    }
    
    /**
    Stops the timer by deactivating the timer, and allows for possibility for the countdown to start again
     */
    func stopCountdown() {
        // Stop the timer and deactivate alarm
        self.countTimer?.invalidate()
        self.timerActive = false
        
    }
   
    /**
    Convert time in seconds to a string
    Parameters:
    - time: time until alarm goes off
    Returns:  string(hour,minute,second)
     */
    private func stringFromTimeinSeconds (time: NSInteger) -> NSString {
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    /**
        Helper function to update the hour, minute,limt
     Parameters:
     - stringTime: a string representing the time interval: format "hour:minute:second"
     */
    private func updateCounterLabels(stringTime: NSString) {
        let timeComponents = stringTime.components(separatedBy: ":")
        let hour = timeComponents[0]
        let minute = timeComponents[1]
        let seconds = timeComponents[2]
        
        self.hourLabel.text = hour
        self.minuteLabel.text = minute
        self.secondsLabel.text = seconds
    }

}
