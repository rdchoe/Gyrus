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
    /// An array holding the hours of the day
    private let hours: [Int] = [Int](0...12)
    /// An array holding the minutes of the day  **single digit minutes should be specially handled ex. 1 -> 01**
    private let minutes: [Int] = [Int](0...60)
    /// An array holding the AM and PM time periods
    private let period: [String] = ["AM", "PM"]
    
    /// The view surrounding the currently selected time *the currently selected time the rows that are currently in the middle of the tableviews
    private lazy var selectionBoxView: UIView = {
        let selectionBoxView = UIView()
        selectionBoxView.translatesAutoresizingMaskIntoConstraints = false
        selectionBoxView.layer.borderColor = #colorLiteral(red: 0.6415534616, green: 0.6621769071, blue: 0.6961867809, alpha: 1)
        selectionBoxView.layer.borderWidth = 3.0
        selectionBoxView.layer.cornerRadius = 5.0
        return selectionBoxView
    }()
    /// The table view holding the hours in a day
    private lazy var hoursTableView: UITableView = {
        let hoursTableView = UITableView()
        hoursTableView.translatesAutoresizingMaskIntoConstraints = false
        hoursTableView.backgroundColor = UIColor.clear
        hoursTableView.dataSource = self
        hoursTableView.delegate = self
        hoursTableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
        hoursTableView.showsVerticalScrollIndicator = false
        hoursTableView.allowsSelection = false
        return hoursTableView
    }()
    /// The table view holding the minutes in a day
    private lazy var minutesTableView: UITableView = {
        let minutesTableView = UITableView()
        minutesTableView.translatesAutoresizingMaskIntoConstraints = false
        minutesTableView.backgroundColor = UIColor.clear
        minutesTableView.dataSource = self
        minutesTableView.delegate = self
        minutesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
        minutesTableView.showsVerticalScrollIndicator = false
        minutesTableView.allowsSelection = false
        return minutesTableView
    }()
    /// The table view holding the time periods in a day (AM / PM)
    private lazy var timePeriodTableView: UITableView = {
        let timePeriodTableView = UITableView()
        timePeriodTableView.translatesAutoresizingMaskIntoConstraints = false
        timePeriodTableView.backgroundColor = UIColor.clear
        timePeriodTableView.dataSource = self
        timePeriodTableView.delegate = self
        timePeriodTableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
        timePeriodTableView.showsVerticalScrollIndicator = false
        timePeriodTableView.allowsSelection = false

        return timePeriodTableView
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
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        self.setupView()
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
        addSubview(selectionBoxView)
        addSubview(horizontalStackView)
        setupLayout()
    }
    
    private func setupLayout() {
        selectionBoxView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        selectionBoxView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        selectionBoxView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        selectionBoxView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.33).isActive = true
        
        
        horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
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
        self.layer.mask = gradient
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        cell.textLabel?.font = UIFont(name: "futura", size: 22)
        cell.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.textLabel?.textAlignment = .center
        if tableView == self.hoursTableView  {
            cell.textLabel?.text = String(self.hours[indexPath.row % self.hours.count])
            return cell
        } else if tableView == self.minutesTableView {
            let minute = self.minutes[indexPath.row % self.minutes.count]
            // Case handle for single digit minutes
            if minute < 10 {
                cell.textLabel?.text = "0" + String(minute)
            } else {
                cell.textLabel?.text = String(minute)
            }
            return cell
        } else if tableView == self.timePeriodTableView {
            if indexPath.row > 0 && indexPath.row < 3 {
                cell.textLabel?.text = String(self.period[indexPath.row-1])
                return cell
            } else {
                return cell
            }
        }
        return UITableViewCell()
    }
   
    /// Using the will display delegate method to generate haptic feedback when cell enters view
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
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
                    scrollToNearestRow(in: self.hoursTableView)
                } else if tableview == self.minutesTableView {
                    scrollToNearestRow(in: self.minutesTableView)
                } else if tableview == self.timePeriodTableView {
                    scrollToNearestRow(in: self.timePeriodTableView)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let tableview = scrollView as? UITableView {
            if tableview == self.hoursTableView {
                scrollToNearestRow(in: self.hoursTableView)
            } else if tableview == self.minutesTableView {
                scrollToNearestRow(in: self.minutesTableView)
            } else if tableview == self.timePeriodTableView {
                scrollToNearestRow(in: self.timePeriodTableView)
            }
        }
    }
    
    
   /**
        Scrolls the table view row that is most in the center to the middle
        - Parameters:
            - tableView: the table view to scroll
    */
    private func scrollToNearestRow(in tableView: UITableView) {
        
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
        
        if let indexPath = tableView.indexPath(for: winningCell) {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        } else {
            print("found no winning cell??")
        }
    }
    
    
}