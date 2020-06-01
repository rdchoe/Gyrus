//
//  TimePickerCellView.swift
//  Gyrus
//
//  Created by Robert Choe on 6/1/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

class TimePickerCellView: UITableViewCell {
    
    var timePickerLabel: UILabel = {
        let timePickerLabel = UILabel()
        timePickerLabel.translatesAutoresizingMaskIntoConstraints = false
        timePickerLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.timePickerFontSize)
        timePickerLabel.textAlignment = .center
        timePickerLabel.lineBreakMode = .byClipping
        return timePickerLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(timePickerLabel)
        
        NSLayoutConstraint.activate([
            timePickerLabel.topAnchor.constraint(equalTo: self.topAnchor),
            timePickerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            timePickerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timePickerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
