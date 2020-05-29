//
//  GyrusTabBarController.swift
//  Gyrus
//
//  Created by Robert Choe on 5/28/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

class GyrusTabBarController: UITabBarController {
    
    private var mainEventButton: UIButton = {
       let mainEventButton = UIButton()
        mainEventButton.frame.size = CGSize(width: 80, height: 80)
        mainEventButton.backgroundColor = Constants.colors.blue
        mainEventButton.layer.cornerRadius = mainEventButton.frame.width / 2
        mainEventButton.clipsToBounds = false
        mainEventButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 80)
        
        // adding drop shadow
        mainEventButton.layer.shadowColor = UIColor.black.cgColor
        mainEventButton.layer.shadowOpacity = 0.5
        mainEventButton.layer.shadowOffset = .zero
        mainEventButton.layer.shadowRadius = 10
        mainEventButton.layer.shouldRasterize = true
        mainEventButton.layer.rasterizationScale = UIScreen.main.scale

        mainEventButton.addTarget(self, action: #selector(animateButton(button:)), for: .touchUpInside)
        return mainEventButton
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        object_setClass(self.tabBar, GyrusTabBar.self)
        (self.tabBar as? GyrusTabBar)?.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewController()
        let alarmPage = GyrusCreateAlarmPageViewController()
        alarmPage.tabBarItem = UITabBarItem(title: "Alarm", image: #imageLiteral(resourceName: "napping"), tag: 0)
        let alarmPag2 = GyrusCreateAlarmPageViewController()
        alarmPag2.tabBarItem = UITabBarItem(title: "Alarm", image: #imageLiteral(resourceName: "napping"), tag: 1)
        let page3 = GyrusCreateAlarmPageViewController()
        page3.tabBarItem = UITabBarItem(title: "Alarm", image: #imageLiteral(resourceName: "napping"), tag: 2)
        let page4 = GyrusCreateAlarmPageViewController()
        page4.tabBarItem = UITabBarItem(title: "Alarm", image: #imageLiteral(resourceName: "napping"), tag: 2)
        self.viewControllers = [alarmPage, alarmPag2, page3, page4]
        
        //self.tabBar.barTintColor = UIColor.clear
        
        //self.tabBar.isTranslucent = true
        
        self.loadGyrusTabBar()
    }
    
    private func loadGyrusTabBar() {
        
    }
    
    func setupCustomTabMenu(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
    // handle creation of the tab bar and attach touch event listeners
        }
    func changeTab(tab: Int) {
            self.selectedIndex = tab
        }
    }
    
    private func setupViewController() {
        mainEventButton.center = CGPoint(x: tabBar.frame.width/2, y: -10)
        self.tabBar.addSubview(mainEventButton)
        
    }
    
    @objc fileprivate func mainEventButtonClicked(sender: UIButton) {
        self.animateButton(button: sender)
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
