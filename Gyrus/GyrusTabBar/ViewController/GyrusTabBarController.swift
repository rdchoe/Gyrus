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

        //mainEventButton.addTarget(self, action: #selector(animateButton(button:)), for: .touchUpInside)
        return mainEventButton
    }()
    
    var gyrusTabBar: GyrusTabBar!
    var tabBarHeight: CGFloat = Constants.tabbar.tabbbarHeight
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        //object_setClass(self.tabBar, GyrusTabBar.self)
        //(self.tabBar as? GyrusTabBar)?.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
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
         */
        
        //self.tabBar.barTintColor = UIColor.clear
        
        //self.tabBar.isTranslucent = true
        
        self.loadGyrusTabBar()
    }
    
    private func loadGyrusTabBar() {
        let tabItems: [TabItem] = [.alarm]
        self.setupCustomTabBar(tabItems) { (controllers) in
            self.viewControllers = controllers
        }
        self.selectedIndex = 0 // default our selected index to the first item
    }
    
    func setupCustomTabBar(_ items: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        // handle creation of the tab bar and attach touch event listeners
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        // hide the tab bar
        tabBar.isHidden = true
        self.gyrusTabBar = GyrusTabBar(menuItems: items, frame: frame)
        self.gyrusTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.gyrusTabBar.clipsToBounds = false
        self.gyrusTabBar.itemTapped = self.changeTab
        // Add it to the view
        self.view.addSubview(gyrusTabBar)
        // Add positioning constraints to place the nav menu right where the tab bar should be
        NSLayoutConstraint.activate([
            self.gyrusTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            self.gyrusTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            self.gyrusTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            self.gyrusTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight), // Fixed height for nav menu
            self.gyrusTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
        for i in 0 ..< items.count {
            controllers.append(items[i].viewController) // we fetch the matching view controller and append here
        }
        self.view.layoutIfNeeded() // important step
        completion(controllers) // setup complete. handoff here
    }
    
    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
    /*
    private func setupViewController() {
        mainEventButton.center = CGPoint(x: tabBar.frame.width/2, y: -10)
        self.tabBar.addSubview(mainEventButton)
        
    }
    */
}
