//
//  SceneDelegate.swift
//  Gyrus
//
//  Created by Robert Choe on 5/25/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = (scene as? UIWindowScene) {
            let window = UIWindow(windowScene: windowScene)
            let tabBarController = GyrusTabBarController()
            UITabBar.setTransparentTabbar()
            
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

    func loadPresetCategories() {
        AppDelegate.appCoreDateManager.addCategory(name: "Chased", emoji: "💨")
        AppDelegate.appCoreDateManager.addCategory(name: "Attacked", emoji: "👹")
        AppDelegate.appCoreDateManager.addCategory(name: "Injured", emoji: "🤕")
        AppDelegate.appCoreDateManager.addCategory(name: "Dying", emoji: "☠️")
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
    func createTagsTest() {
        AppDelegate.appCoreDateManager.deleteAllCategories()
        
        AppDelegate.appCoreDateManager.addCategory(name: "Falling", emoji: "🌩")
        AppDelegate.appCoreDateManager.addCategory(name: "Super Powers", emoji: "🦸🏻‍♂️")
        AppDelegate.appCoreDateManager.addCategory(name: "Very long category", emoji: "🌩")
        AppDelegate.appCoreDateManager.addCategory(name: "Good Dream", emoji: "☺️")
        AppDelegate.appCoreDateManager.deleteAllCategories()
    }

}


