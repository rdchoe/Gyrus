//
//  GyrusTabBar.swift
//  Gyrus
//
//  Created by Robert Choe on 5/29/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

protocol GyrusTabBarDelegate: UIViewController {
    func mainEventButtonClicked(button: UIButton)
}

/**
 Custom UITabbar for Gyrus
 */
@IBDesignable
class GyrusTabBar: UIView {
    /// Implemented with the guide of this tutorial: https://medium.com/sprinthub/creating-a-customized-tab-bar-in-ios-with-swift-41ed380f2a30
    
    /// The shape of the nav bar
    private var shapeLayer: CALayer?
    weak var delegate: GyrusTabBarDelegate?
    var mainEventButton: UIButton = {
       let mainEventButton = UIButton()
        mainEventButton.frame.size = CGSize(width: 80, height: 80)
        mainEventButton.backgroundColor = Constants.colors.buttonColor
        mainEventButton.layer.cornerRadius = mainEventButton.frame.width / 2

        // adding drop shadow
        mainEventButton.layer.shadowColor = UIColor.black.cgColor
        mainEventButton.layer.shadowOpacity = 0.5
        mainEventButton.layer.shadowOffset = .zero
        mainEventButton.layer.shadowRadius = 10
        mainEventButton.layer.shouldRasterize = true
        mainEventButton.layer.rasterizationScale = UIScreen.main.scale

        return mainEventButton
    }()
    
    private var leadingStackView: UIStackView = {
       let leadingStackView = UIStackView()
        leadingStackView.translatesAutoresizingMaskIntoConstraints = false
        leadingStackView.axis = .horizontal
        leadingStackView.distribution = .equalSpacing

        return leadingStackView
    }()
    
    private var trailingStackView: UIStackView = {
       let trailingStackView = UIStackView()
        trailingStackView.translatesAutoresizingMaskIntoConstraints = false
        trailingStackView.axis = .horizontal
        trailingStackView.distribution = .equalCentering
        
        return trailingStackView
    }()
    
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        drawTabBarOutline()
        renderMenuItems(menuItems: menuItems)
        addMainEventButton()
        
    }
    
    func addMainEventButton() {
        mainEventButton.center = CGPoint(x: self.frame.width / 2, y: 0)
        mainEventButton.addTarget(self, action: #selector(mainEventButtonClicked(sender:)), for: .touchUpInside)
        addSubview(mainEventButton)
    }
    
   
    /// This function handles the problem of the raised button (@mainEventButton) not being hit outside the tab bar bounds
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
         if self.isHidden {
             return super.hitTest(point, with: event)
         }
         
         let from = point
         let to = mainEventButton.center

         return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 39 ? mainEventButton : super.hitTest(point, with: event)
     }
    
    
    func renderMenuItems(menuItems: [TabItem]) {
        self.addSubview(leadingStackView)
        self.addSubview(trailingStackView)
        
        NSLayoutConstraint.activate([
            leadingStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 36),
            leadingStackView.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -Constants.tabbar.tabbarRadius - 16),
            leadingStackView.topAnchor.constraint(equalTo: self.topAnchor),
            leadingStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            trailingStackView.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: Constants.tabbar.tabbarRadius + 16),
            trailingStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -36),
            trailingStackView.topAnchor.constraint(equalTo: self.topAnchor),
            trailingStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        // This is what's going through that array of menu items
        let splittedMenuItems = menuItems.splitted()
        let left = splittedMenuItems.0
        let right = splittedMenuItems.1
        
        for (index,menuItem) in left.enumerated() {
            let itemView = self.createTabItem(item: menuItem)
            itemView.tag = index
            leadingStackView.addArrangedSubview(itemView)
        }
        for (index,menuItem) in right.enumerated() {
            let itemView = self.createTabItem(item: menuItem)
            itemView.tag = index + left.count
            trailingStackView.addArrangedSubview(itemView)
        }

        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateTab(tab: 0) // activate the first tab
    }
    
    /**
    Returns a UIView of what this tab bar item should look like
     - Returns: a UIView of what this tab bar item should look like
     */
    func createTabItem(item: TabItem) -> UIView{
        let tabBarItem = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let itemTitleLabel = UILabel(frame: CGRect.zero)
        let itemIconView = UIImageView(frame: CGRect.zero)
        itemIconView.tintColor = .white
        itemTitleLabel.text = item.displayTitle
        itemTitleLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.tabBarSize)
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.clipsToBounds = true
        itemTitleLabel.textColor = Constants.colors.textBlue
        
        itemIconView.image = item.icon.withTintColor(UIColor.white, renderingMode: .automatic)
        itemIconView.translatesAutoresizingMaskIntoConstraints = false
        itemIconView.clipsToBounds = true
        tabBarItem.layer.backgroundColor = UIColor.clear.cgColor
        tabBarItem.addSubview(itemIconView)
        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = true
        NSLayoutConstraint.activate([
            //itemIconView.heightAnchor.constraint(equalToConstant: 25), // Fixed height for our tab item(25pts)
            //itemIconView.widthAnchor.constraint(equalToConstant: 25), // Fixed width for our tab item icon
            itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 8), // Position menu item icon 8pts from the top of it's parent view
            itemTitleLabel.heightAnchor.constraint(equalToConstant: 13), // Fixed height for title label
            itemTitleLabel.widthAnchor.constraint(equalTo: tabBarItem.widthAnchor), // Position label full width across tab bar item
            itemTitleLabel.topAnchor.constraint(equalTo: itemIconView.bottomAnchor, constant: 4), // Position title label 4pts below item icon
        ])
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap))) // Each item should be able to trigger and action on tap
        return tabBarItem
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.switchTab(from: self.activeItem, to: sender.view!.tag)
    }
    
    func switchTab(from: Int, to: Int) {
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }
    
    func activateTab(tab: Int) {
        let tabToActivate = self.subviews[tab]
        let borderWidth = tabToActivate.frame.size.width - 20
        let borderLayer = CALayer()
        // This is adding that green thing on the top
        borderLayer.backgroundColor = UIColor.white.cgColor
        borderLayer.name = "active border"
        borderLayer.frame = CGRect(x: 10, y: 0, width: borderWidth, height: 2)
        DispatchQueue.main.async {
            self.itemTapped?(tab)
        }
        self.activeItem = tab
    }
    
    func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[tab]
        let layersToRemove = inactiveTab.layer.sublayers!.filter({ $0.name == "active border" })
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                layersToRemove.forEach({ $0.removeFromSuperlayer() })
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            })
        }
    }
    
    private func drawTabBarOutline()  {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPathCircle()
        shapeLayer.strokeColor = Constants.colors.gray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = Constants.tabbar.tabbarLineWidth
       
        // Replacing the current shape layer on the tab bar
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    private func createPathCircle() -> CGPath {
        
        let radius: CGFloat = Constants.tabbar.tabbarRadius
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        // Drawing out the path
        path.move(to: CGPoint(x: 0, y: 0)) // Top left
        path.addLine(to: CGPoint(x: centerWidth - radius , y: 0)) // start of circle
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0)) // Top Right
        return path.cgPath
    }
    
    private func setupMiddleButton() {
        addSubview(self.mainEventButton)
    }
    
    // MARK: mainEventButton-
    @objc fileprivate func mainEventButtonClicked(sender: UIButton) {
        // Toggle selected state of the button
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        self.animateButton(button: sender)
        self.delegate?.mainEventButtonClicked(button: sender)
    }
    
    @objc fileprivate func animateButton(button: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            button.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                button.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
}
