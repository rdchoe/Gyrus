//
//  PushNotificationManager.swift
//  Gyrus
//
//  Created by Robert Choe on 6/1/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit
import UserNotifications

class PushNotificationManager: NSObject {
    override init() {
        super.init()
    }
    
    static func createLocalNotification(alarm: Alarm) {
        let notifcationCenter = UNUserNotificationCenter.current()
        
        notifcationCenter.requestAuthorization(options: [.alert,.sound]) {(grandted, error) in
            
        }
        notifcationCenter.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
            // Notifications not allowed
          }
        }
        let content = UNMutableNotificationContent()
        if alarm.name == "" {
            content.title = "Alarm"
        } else {
            content.title = alarm.name!
        }
        content.userInfo = ["alarmID": alarm.id!.uuidString]
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute,.day], from: alarm.time!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
         
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        notifcationCenter.add(request) { (error) in
            if error != nil  {
                // handle errors here
            }
        }
    }
    
    
    static func removeAllPendingAlarmNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }

}
