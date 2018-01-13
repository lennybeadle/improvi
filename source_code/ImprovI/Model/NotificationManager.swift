//
//  NotificationManager.swift
//  ImprovI
//
//  Created by Macmini on 2/5/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject {
    static let sharedInstance = NotificationManager()
    
    func setNotification(with identifier: String, name: String, time: Date, content: String, isRepeat: Bool) {
        self.removeNotification(with: identifier)
        
        var needsToRepeat = Repeats.None
        if isRepeat {
            needsToRepeat = Repeats.Daily
        }
        let dlnotification = LJNotification(identifier: identifier, alertTitle: name, alertBody: content, date: time, repeats: needsToRepeat)
        _ = LJNotificationScheduler.sharedInstance.scheduleNotification(notification: dlnotification) //return notification identifier
    }
    
    func removeNotification(with identifier: String) {
        LJNotificationScheduler.sharedInstance.cancelNotification(with: identifier)
        
    }
    
    func getNotificationInfo(with identifier: String, completion: ((Date?, _ title: String, _ content: String)->Void)?){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            if let completion = completion {
                for request in notificationRequests {
                    if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                        completion(trigger.nextTriggerDate(), request.content.title, request.content.body)
                        return
                    }
                }
                completion(nil, "", "")
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        _ = notification.request.content
        // Process notification content
        completionHandler([.alert, .sound]) // Display notification as regular alert and play sound
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        print("Notification posted: " + actionIdentifier )
        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
            // Do something
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
            if Manager.sharedInstance.currentUser != nil {
                let identifier = response.notification.request.identifier
                if identifier == "GENERAL" {
                    Manager.sharedInstance.showProgrammeList()
                }
            }
            // Do something
            completionHandler()
        default:
            completionHandler()
        }
    }
}
