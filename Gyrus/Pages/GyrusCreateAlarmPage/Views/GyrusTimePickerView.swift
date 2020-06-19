//
//  GyrusTimePickerView.swift
//  Gyrus
//
//  Created by Robert Choe on 5/28/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

class GyrusTimePicker: UIView {
    
    /// A boolean indicating if any of the scrollable table views are still being **interacted** with
    var currentlySelectingTime: Bool = false
    /// An array holding the hours of the day
    private let hours: [Int] = [Int](1...12)
    /// An array holding the minutes of the day  **single digit minutes should be specially handled ex. 1 -> 01**
    private let minutes: [Int] = [Int](0...59)
    /// An array holding the AM and PM time periods
    private let period: [String] = ["AM", "PM"]
    /// The view surrounding the currently selected time *the currently selected time the rows that are currently in the middle of the tableviews
    lazy var selectionBoxView: UIView = {
        let selectionBoxView = UIView()
        selectionBoxView.translatesAutoresizingMaskIntoConstraints = false
        selectionBoxView.layer.borderColor = #colorLiteral(red: 0.6415534616, green: 0.6621769071, blue: 0.6961867809, alpha: 1)
        selectionBoxView.layer.borderWidth = 3.0
        selectionBoxView.layer.cornerRadius = 5.0
        return selectionBoxView
    }()
    
    /// Making these constraints on the selection view accessible to allow for animation
    fileprivate var selectionBoxViewTopConstraint: NSLayoutConstraint!
    fileprivate var selectionBoxViewBottomConstraint: NSLayoutConstraint!
    fileprivate var selectionBoxViewHeightAnchor: NSLayoutConstraint!
    
    /// The table view holding the hours in a day
    private lazy var hoursTableView: UITableView = {
        let hoursTableView = UITableView()
        hoursTableView.translatesAutoresizingMaskIntoConstraints = false
        hoursTableView.backgroundColor = UIColor.clear
        hoursTableView.dataSource = self
        hoursTableView.delegate = self
        hoursTableView.register(TimePickerCellView.self, forCellReuseIdentifier: "timePickerCell")
        hoursTableView.showsVerticalScrollIndicator = false
        hoursTableView.allowsSelection = false
        hoursTableView.separatorColor = UIColor.clear
        return hoursTableView
    }()
    /// The table view holding the minutes in a day
    private lazy var minutesTableView: UITableView = {
        let minutesTableView = UITableView()
        minutesTableView.translatesAutoresizingMaskIntoConstraints = false
        minutesTableView.backgroundColor = UIColor.clear
        minutesTableView.dataSource = self
        minutesTableView.delegate = self
        minutesTableView.register(TimePickerCellView.self, forCellReuseIdentifier: "timePickerCell")
        minutesTableView.showsVerticalScrollIndicator = false
        minutesTableView.allowsSelection = false
        minutesTableView.separatorColor = UIColor.clear
        return minutesTableView
    }()
    /// The table view holding the time periods in a day (AM / PM)
    private lazy var timePeriodTableView: UITableView = {
        let timePeriodTableView = UITableView()
        timePeriodTableView.translatesAutoresizingMaskIntoConstraints = false
        timePeriodTableView.backgroundColor = UIColor.clear
        timePeriodTableView.dataSource = self
        timePeriodTableView.delegate = self
        timePeriodTableView.register(TimePickerCellView.self, forCellReuseIdentifier: "timePickerCell")
        timePeriodTableView.showsVerticalScrollIndicator = false
        timePeriodTableView.allowsSelection = false
        timePeriodTableView.separatorColor = UIColor.clear

        return timePeriodTableView
    }()
    
    private lazy var stackViewWrapper: UIView = {
        let stackViewWrapper = UIView()
        stackViewWrapper.translatesAutoresizingMaskIntoConstraints = false
        stackViewWrapper.backgroundColor = UIColor.clear
        return stackViewWrapper
    }()
    /// The horizontal stack view containing the three table views
    private lazy var horizontalStackView: UIStackView = {
        let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fillEqually
        return horizontalStackView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        self.addGradient()
        hoursTableView.rowHeight = self.bounds.height/3
        minutesTableView.rowHeight = self.bounds.height/3
        timePeriodTableView.rowHeight = self.bounds.height/3
    }

    private func setupView() {
        horizontalStackView.addArrangedSubview(hoursTableView)
        horizontalStackView.addArrangedSubview(minutesTableView)
        horizontalStackView.addArrangedSubview(timePeriodTableView)
        stackViewWrapper.addSubview(horizontalStackView)
        addSubview(selectionBoxView)
        addSubview(stackViewWrapper)
        //addSubview(horizontalStackView)
        setupLayout()
        
        self.minutesTableView.scrollToRow(at: IndexPath(row: 500, section: 0), at: .top, animated: true)
        self.hoursTableView.scrollToRow(at: IndexPath(row: 500, section: 0), at: .top, animated: true)
    }
    
    private func setupLayout() {
        selectionBoxView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        selectionBoxView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        selectionBoxView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.selectionBoxViewHeightAnchor = selectionBoxView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.33)
        self.selectionBoxViewHeightAnchor.isActive = true
        
        stackViewWrapper.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackViewWrapper.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackViewWrapper.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackViewWrapper.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        horizontalStackView.topAnchor.constraint(equalTo: stackViewWrapper.topAnchor).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: stackViewWrapper.bottomAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: stackViewWrapper.leadingAnchor).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: stackViewWrapper.trailingAnchor).isActive = true
    }
    
    //custom views should override this to return true if
    //they cannot layout correctly using autoresizing.
    //from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
    override class var requiresConstraintBasedLayout: Bool {
    return true
    }

    /**
        Fades in and out the content of the time picker. Rows that are not in the seleciton view are slightly faded out
     */
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        
        self.stackViewWrapper.layer.mask = gradient
    }
}


extension GyrusTimePicker: UITableViewDelegate, UITableViewDataSource {
    // MARK: Table View Delegate-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.hoursTableView  {
            return self.hours.count * 1000
        } else if tableView == self.minutesTableView {
            return self.minutes.count * 1000
        } else if tableView == self.timePeriodTableView {
            return 4
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timePickerCell", for: indexPath) as! TimePickerCellView
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        if tableView == self.hoursTableView  {
            cell.timePickerLabel.text = String(self.hours[indexPath.row % self.hours.count])
            return cell
        } else if tableView == self.minutesTableView {
            let minute = self.minutes[indexPath.row % self.minutes.count]
            // Case handle for single digit minutes
            if minute < 10 {
                cell.timePickerLabel.text = "0" + String(minute)
            } else {
                cell.timePickerLabel.text = String(minute)
            }
            return cell
        } else if tableView == self.timePeriodTableView {
            if indexPath.row > 0 && indexPath.row < 3 {
                cell.timePickerLabel
                    .text = String(self.period[indexPath.row-1])
                return cell
            } else {
                return cell
            }
        }
        return UITableViewCell()
    }
   
    /// Using the will display delegate method to generate haptic feedback when cell enters view
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        if tableView == self.hoursTableView  {
            generator.impactOccurred()
        } else if tableView == self.minutesTableView {
            generator.impactOccurred()
        } else if tableView == self.timePeriodTableView {
            generator.impactOccurred()
        }
    }
    
    // MARK: ScollView-
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            if let tableview = scrollView as? UITableView {
                if tableview == self.hoursTableView {
                    self.hoursTableView.currentlyScrolling = false
                    scrollToNearestRow(in: self.hoursTableView)
                } else if tableview == self.minutesTableView {
                    self.minutesTableView.currentlyScrolling = false
                    scrollToNearestRow(in: self.minutesTableView)
                } else if tableview == self.timePeriodTableView {
                    self.timePeriodTableView.currentlyScrolling = false
                    scrollToNearestRow(in: self.timePeriodTableView)
                }
            }
        }
        // If none of the table views are currently scrolling then the user is not currently selecting a time
        if !hoursTableView.currentlyScrolling && !minutesTableView.currentlyScrolling && !timePeriodTableView.currentlyScrolling {
            self.currentlySelectingTime = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let tableview = scrollView as? UITableView {
            if tableview == self.hoursTableView {
                self.hoursTableView.currentlyScrolling = false
                scrollToNearestRow(in: self.hoursTableView)
            } else if tableview == self.minutesTableView {
                self.minutesTableView.currentlyScrolling = false
                scrollToNearestRow(in: self.minutesTableView)
            } else if tableview == self.timePeriodTableView {
                self.timePeriodTableView.currentlyScrolling = false
                scrollToNearestRow(in: self.timePeriodTableView)
            }
        }
        
        // If none of the table views are currently scrolling then the user is not currently selecting a time
        if !hoursTableView.currentlyScrolling && !minutesTableView.currentlyScrolling && !timePeriodTableView.currentlyScrolling {
            self.currentlySelectingTime = false
        }
        
    }
    
    
    
 
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let tableview = scrollView as? UITableView {
            if tableview == self.hoursTableView {
                self.hoursTableView.currentlyScrolling = true
            } else if tableview == self.minutesTableView {
                self.minutesTableView.currentlyScrolling = true
            } else if tableview == self.timePeriodTableView {
                self.timePeriodTableView.currentlyScrolling = true
            }
        }
        self.currentlySelectingTime = true
    }
    
    private func getRowInMiddle(in tableView: UITableView) -> IndexPath? {
        var maxArea: CGFloat = 0.0
        var winningCell: UITableViewCell = UITableViewCell()
        var cellOriginY: CGFloat
        var endYinRange: CGFloat
        var startYinRange: CGFloat
        var area: CGFloat
        for cell in tableView.visibleCells {
            cellOriginY = tableView.convert(cell.frame.origin, to: tableView.superview).y
            endYinRange = min(cellOriginY + tableView.rowHeight, tableView.rowHeight * 2)
            startYinRange = max(cellOriginY,tableView.rowHeight)
            area = endYinRange - startYinRange
            if area > maxArea {
                maxArea = area
                winningCell = cell
            }
        }
        return tableView.indexPath(for: winningCell)
    }
   /**
        Scrolls the table view row that is most in the center to the middle
        - Parameters:
            - tableView: the table view to scroll
    */
    private func scrollToNearestRow(in tableView: UITableView) {
        if let indexPath = getRowInMiddle(in: tableView) {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    /**
     Gets the time the currently selected
     - Returns: Date object representing the time selected
     */
    func getSelectedTime() -> Date? {
        var alarmTime: Date?
        var hour: Int = 0
        var minute: Int = 0
        var timePeriod: String = ""
        if let middleHourIndexPath = getRowInMiddle(in: self.hoursTableView) {
            let cell = self.hoursTableView.cellForRow(at: middleHourIndexPath)! as! TimePickerCellView
            hour = Int(cell.timePickerLabel.text!)!
        }
        if let middleMinuteIndexPath = getRowInMiddle(in: self.minutesTableView) {
            let cell = self.minutesTableView.cellForRow(at: middleMinuteIndexPath)! as! TimePickerCellView
            minute = Int(cell.timePickerLabel.text!)!
        }
        if let middleTimePeriodIndexPath = getRowInMiddle(in: self.timePeriodTableView) {
            let cell = self.timePeriodTableView.cellForRow(at: middleTimePeriodIndexPath)! as! TimePickerCellView
            timePeriod = cell.timePickerLabel.text!
            if timePeriod == "PM" && hour != 12 {
                hour += 12
            }
        }
        let currDate = Date()
        
        let currHour = Calendar.current.component(.hour, from: currDate)
        let currMinute = Calendar.current.component(.minute, from: currDate)
        if hour <= currHour { // Alarm is on the next day (possibly)
            if hour == currHour &&  minute > currMinute { // curr: 4:30  alarm: 4:34 -> same day exception
                alarmTime = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: currDate)
            } else if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currDate) {
                alarmTime = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: nextDay)
            } else {
                return nil
            }
        } else {
           alarmTime = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: currDate)
        }

        return alarmTime
        
    }
    
    func animateSelectionView(mainEventButton: UIButton) {
        self.removeConstraint(self.selectionBoxViewHeightAnchor)
        if (mainEventButton.isSelected) {
            //self.alpha = 0
            self.selectionBoxViewHeightAnchor = self.selectionBoxView.heightAnchor.constraint(equalTo:  self.heightAnchor, multiplier: 1.0)
            let timePickerFrame = self.frame
            //timePickerFrame.origin.y -= 250
            self.frame = timePickerFrame
        } else {
            //self.alpha = 1
            self.selectionBoxViewHeightAnchor = self.selectionBoxView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.33)
        }
        self.addConstraint(self.selectionBoxViewHeightAnchor)
        
        
        self.layoutIfNeeded()
        /*
        UIView.animate(withDuration: 0.75, delay: 0.5, options: .curveEaseIn, animations: {
            
        }, completion: { _ in
            //mainEventButton.isUserInteractionEnabled = true
        })
        */
        
    }
}
