//
//  SceneDelegate.swift
//  Gyrus
//
//  Created by Robert Choe on 5/25/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit
import SwiftyJSON

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = (scene as? UIWindowScene) {
            let window = UIWindow(windowScene: windowScene)
            let navController = UINavigationController()

            let tabBarController = GyrusTabBarController()
            UITabBar.setTransparentTabbar()
            
            navController.viewControllers = [tabBarController]
            
            stylizeNavigationBar()
            
            window.rootViewController = tabBarController
            self.window = window
            window.makeKeyAndVisible()
            let defaults = UserDefaults.standard
            let returningUser = defaults.bool(forKey: "returningUser")
            if returningUser == false {
                loadPresetCategories()
                defaults.set(true, forKey: "returningUser")
            } else {
                print("returning user")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func stylizeNavigationBar() {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.colors.activeColor, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size:20)], for: .normal)
        
        let backIndicator = #imageLiteral(resourceName: "back_arrow")
        UINavigationBar.appearance().backIndicatorImage = backIndicator
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backIndicator
        UINavigationBar.appearance().tintColor = Constants.colors.activeColor
        
    }

    /**
     Being Chased
     Falling
     Flying
     Death
     Naked
     Water
     Sex
     Money
     House
     Teeth
     Journey
     */
    func loadPresetCategories() {
        AppDelegate.appCoreDateManager.addCategory(name: "Flying", emoji: "🦋")
        AppDelegate.appCoreDateManager.addCategory(name: "Naked", emoji: "🥴")
        AppDelegate.appCoreDateManager.addCategory(name: "Sex", emoji: "🍆")
        AppDelegate.appCoreDateManager.addCategory(name: "Water", emoji: "🌊")
        AppDelegate.appCoreDateManager.addCategory(name: "Money", emoji: "💰")
        AppDelegate.appCoreDateManager.addCategory(name: "House", emoji: "🏠")
        AppDelegate.appCoreDateManager.addCategory(name: "Teeth", emoji: "🦷")
        AppDelegate.appCoreDateManager.addCategory(name: "Journey", emoji: "🚶🏼‍♂️")
        AppDelegate.appCoreDateManager.addCategory(name: "Chased", emoji: "💨")
        AppDelegate.appCoreDateManager.addCategory(name: "Attacked", emoji: "👹")
        AppDelegate.appCoreDateManager.addCategory(name: "Injured", emoji: "🤕")
        AppDelegate.appCoreDateManager.addCategory(name: "Death", emoji: "☠️")
        AppDelegate.appCoreDateManager.addCategory(name: "Car", emoji: "🚗")
        AppDelegate.appCoreDateManager.addCategory(name: "House Damage", emoji: "🏠")
        AppDelegate.appCoreDateManager.addCategory(name: "Poor Performance", emoji: "😕")
        AppDelegate.appCoreDateManager.addCategory(name: "Falling", emoji: "⛷")
        AppDelegate.appCoreDateManager.addCategory(name: "Drowning", emoji: "💧")
        AppDelegate.appCoreDateManager.addCategory(name: "Public Embarrassment", emoji: "🥴")
        AppDelegate.appCoreDateManager.addCategory(name: "Being Late", emoji: "🏃‍♂️")
        AppDelegate.appCoreDateManager.addCategory(name: "Telephone Malfunction", emoji: "☎️")
        AppDelegate.appCoreDateManager.addCategory(name: "Natural Disasters", emoji: "🌪")
        AppDelegate.appCoreDateManager.addCategory(name: "Lost", emoji: "🏝")
        AppDelegate.appCoreDateManager.addCategory(name: "Trapped", emoji: "📦")
        AppDelegate.appCoreDateManager.addCategory(name: "Ghost", emoji: "👻")
    }
}


