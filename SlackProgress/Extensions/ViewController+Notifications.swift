//
//  ViewController+Notifications.swift
//  SlackProgress
//
//  Created by Salmaan Ahmed on 20/05/2019.
//  Copyright © 2019 Salmaan Ahmed. All rights reserved.
//

import Foundation
import UserNotifications

extension ViewController : UNUserNotificationCenterDelegate {
    func requestUserNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    func clearNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Hey, progress reminder"
        content.body = "Shhh!!! Put few tasks in progress if you havent and let me know, I'll send the report."
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        for weekDay in weekDays {
            var dateComponents = DateComponents()
            dateComponents.hour = 18
            dateComponents.minute = 00
            dateComponents.weekday = weekDay
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    func registerListeners() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Send Status", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            // the user swiped to unlock
            print("Do nothing")
            
        case "show":
            // the user tapped our "show more info…" button
            print("Send progress report")
            sendStatus()
            break
            
        default:
            break
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }
}
