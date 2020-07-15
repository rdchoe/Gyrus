//
//  CategoryTableViewCell.swift
//  Gyrus
//
//  Created by Robert Choe on 6/30/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    lazy var categoryLabel: UILabel = {
        let cl = UILabel()
        cl.translatesAutoresizingMaskIntoConstraints = false
        cl.font = UIFont(name: Constants.font.futura, size: Constants.category.fontSize)
        cl.textColor = Constants.colors.white
        return cl
    }()
    
    lazy var checkMark: UIImageView = {
        let font = UIFont.systemFont(ofSize: 18)
        let configuration = UIImage.SymbolConfiguration(scale: .small)
        let check = UIImage(systemName: "checkmark", withConfiguration: configuration)!.imageWithColor(color: Constants.colors.activeColor)
        let iv = UIImageView(image: check)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
   
    var category: Category! {
        didSet {
            self.categoryLabel.text = "\(category.emoji!) \(category.name!)"
            self.contentView.addSubview(checkMark)
            self.contentView.addSubview(categoryLabel)
            layoutConstraints()
        }
    }
    
    static let identifier = "CategoryTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.isSelected {
            categoryLabel.alpha = 1.0
            checkMark.isHidden = false
        } else {
            categoryLabel.alpha = 0.5
            checkMark.isHidden = true
        }
    }
    
    fileprivate func layoutConstraints() {
        let views: [String: Any] = ["checkMark": self.checkMark, "categoryLabel": self.categoryLabel, "contentView": self.contentView]
        [
            "H:|[contentView]|",
            "V:|[contentView]|",
            "H:|-[categoryLabel]-(>=8)-[checkMark]-|",
            "V:|-[categoryLabel]-|",
            "V:|-[checkMark]-|"
        ].forEach{NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: nil, views: views))}
    }

}
