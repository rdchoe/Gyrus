//
//  DreamCollectionViewCell.swift
//  Gyrus
//
//  Created by Robert Choe on 6/29/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

class DreamCollectionViewCell: UICollectionViewCell {
    private let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: Constants.font.futura, size: Constants.font.h6)
        title.textColor = Constants.colors.white
        
        return title
    }()
    
    private let date: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = UIFont(name: Constants.font.futura, size: Constants.font.subtitle)
        date.textColor = Constants.colors.gray
        return date
    }()
    
    private let content: UILabel = {
        let content = UILabel()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = UIFont(name: Constants.font.futura_light, size: Constants.font.subtitle)
        content.textColor = Constants.colors.gray
        return content
    }()
    
    private let separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = Constants.colors.gray
        return separator
    }()
    
    var dream: Dream! {
        didSet {
            let dateFormat = "MM/dd/yy"
            dateFormatter.dateFormat = dateFormat
            title.text = dream.title
            date.text = dateFormatter.string(from: dream.date!)
            content.text = dream.content
            self.contentView.addSubview(title)
            self.contentView.addSubview(date)
            self.contentView.addSubview(content)
            self.contentView.addSubview(separator)
            layoutConstraints()
        }
    }
    
    static let identifier = "DreamCell"
    private let dateFormatter = DateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
        
        //layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutConstraints() {
        let views : [String: Any] = ["title": self.title, "date": self.date, "content": self.content, "contentView": self.contentView, "separator":self.separator]
        ["H:|-[contentView]|",
         "V:|-[contentView]-|",
         "V:|[title]-[date]|",
         "V:|[title]-10-[content]-[separator(0.5)]",
         "H:|[title]|",
         "H:|[date]-[content]",
         "H:|[separator]|"
            ].forEach{NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: nil, views: views))}
    }
}
