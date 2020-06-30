//
//  GyrusTabBarController.swift
//  Gyrus
//
//  Created by Robert Choe on 5/28/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class GyrusTabBarController: UITabBarController, UNUserNotificationCenterDelegate {
    
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
    var gyrusTabBarBottomAnchor: NSLayoutConstraint!
    
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
        self.loadGyrusTabBar()
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func loadGyrusTabBar() {
        let tabItems: [TabItem] = [.alarm, .dreams]
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
            self.gyrusTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight) // Fixed height for nav menu
            //self.gyrusTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
        
        self.gyrusTabBarBottomAnchor = self.gyrusTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        self.gyrusTabBarBottomAnchor.isActive = true
        for i in 0 ..< items.count {
            controllers.append(items[i].viewController) // we fetch the matching view controller and append here
        }
        self.view.layoutIfNeeded() // important step
        completion(controllers) // setup complete. handoff here
    }
    
    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Turning down the volume
        MPVolumeView.setVolume(0.5)
        print(response.notification.request.content.userInfo)
        
        // Opening the app from an alarm local notification
        // 1. Change tab to the all dream logs page view controller
        self.changeTab(tab: 1)
        if let navController = self.viewControllers?[1] as? UINavigationController {
            if let allLogsController = navController.viewControllers[0] as? GyrusAllLogsPageViewController {
                // 2. Open up the create log page
                allLogsController.openCreateLog()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(_:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    @objc func volumeChanged(_ notifcation: NSNotification) {
        MPVolumeView.setVolume(0.5)
    }
    
    func hideTabBar() {
        UIView.animate(withDuration: 0.5, delay: 0.0 ,options: .curveEaseInOut, animations: {
            self.gyrusTabBarBottomAnchor.constant = 150.0
            self.gyrusTabBar.isUserInteractionEnabled = false
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func showTabBar() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.gyrusTabBarBottomAnchor.constant = 0.0
            self.gyrusTabBar.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
            self.navigationController?.navigationBar.makeTransparent()
        }, completion: nil)
    }
}
