//
//  DreamsHeaderView.swift
//  Gyrus
//
//  Created by Robert Choe on 6/29/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

class DreamsHeaderView: UICollectionReusableView {
    
    fileprivate let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Related dreams"
        headerLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.body)
        headerLabel.textColor = Constants.colors.white
        return headerLabel
    }()
    
    let dreamCountLabel: UILabel = {
        let dreamCountLabel = UILabel()
        dreamCountLabel.translatesAutoresizingMaskIntoConstraints = false
        dreamCountLabel.font = UIFont(name: Constants.font.futura_light, size: Constants.font.subtitle)
        dreamCountLabel.textColor = Constants.colors.white
        return dreamCountLabel
    }()
    
    fileprivate let separator: UIView = {
         let separator = UIView()
         separator.translatesAutoresizingMaskIntoConstraints = false
         separator.backgroundColor = Constants.colors.gray
         return separator
     }()
    
    static let identifier = "DreamsHeader"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        addSubview(headerLabel)
        addSubview(dreamCountLabel)
        addSubview(separator)
        layoutConstraints()
    }
    
    fileprivate func layoutConstraints() {
        let views: [String: Any] = ["headerLabel": self.headerLabel, "dreamCountLabel":self.dreamCountLabel, "separator":self.separator]
        
        [
            "H:|-16-[headerLabel]",
            "H:|-16-[dreamCountLabel]",
            "H:|[separator]|",
            "V:|-[headerLabel]-[dreamCountLabel]-[separator(1)]|",
        ].forEach{NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: nil, views: views))}
    }
}
