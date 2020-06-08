//
//  CategoryCollectionViewCell.swift
//  Gyrus
//
//  Created by Robert Choe on 6/4/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    private var cellWidthConstraint:NSLayoutConstraint!
    private var cellHeightConstraint: NSLayoutConstraint!
    
    let emoji: UILabel = {
        let emoji = UILabel()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.backgroundColor = UIColor.clear
        emoji.font = UIFont(name: Constants.font.futura_condensed, size: Constants.category.fontSize)
        return emoji
    }()
    
    let categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.backgroundColor = UIColor.clear
        categoryLabel.textColor = Constants.colors.whiteTextColor
        categoryLabel.font = UIFont(name: Constants.font.futura_condensed, size: Constants.category.fontSize)
        return categoryLabel
    }()
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.clear
        return containerView
    }()
    
    var category: Category! {
        didSet {
            categoryLabel.text = "\(category.emoji!) \(category.name!)"
            self.contentView.addSubview(categoryLabel)
            self.layoutConstraints()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.cellWidthConstraint =  self.contentView.widthAnchor.constraint(equalToConstant: 0)
        self.cellHeightConstraint = self.contentView.heightAnchor.constraint(equalToConstant: 0)
        
        self.backgroundColor = #colorLiteral(red: 0.2155992985, green: 0.242302984, blue: 0.2931298018, alpha: 1)
        
        self.layer.borderWidth = 2.0
        self.layer.borderColor = #colorLiteral(red: 0.1141634211, green: 0.1520627439, blue: 0.1904778481, alpha: 1)
    }
    
    private func layoutConstraints() {
        let views: [String: Any] = ["emoji": self.emoji, "categoryLabel": self.categoryLabel, "contentView": self.contentView]
        self.layer.cornerRadius = self.frame.height / 2
        
        ["H:|[contentView]|",
         "V:|[contentView]|",
         "H:|-6-[categoryLabel]-8-|",
         "V:|-4-[categoryLabel]-4-|"
        ].forEach{NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: nil, views: views))}
    }
}
