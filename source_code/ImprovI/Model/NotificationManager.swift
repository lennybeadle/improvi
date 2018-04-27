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
    static let shared = NotificationManager()
    var taskTimeReminder: Int {
        get {
            let standard = UserDefaults.standard
            return standard.integer(forKey: "TASK_TIME_REMINDER")
        }
        set {
            let standard = UserDefaults.standard
            standard.set(newValue, forKey: "TASK_TIME_REMINDER")
        }
    }
    
    var generalReminderEnabled: Bool {
        get {
            let standard = UserDefaults.standard
            return standard.bool(forKey: "generalReminderEnabled")
        }
        set {
            if newValue == generalReminderEnabled {
                return
            }
            
            let standard = UserDefaults.standard
            standard.set(newValue, forKey: "generalReminderEnabled")
            if newValue == false {
                self.removeNotification(with: "GENERAL")
            }
            else {
                self.setNotification(with: "GENERAL", name: "Reminder", time: generalDate, content: generalMessage, isRepeat: true)
            }
        }
    }
    
    var taskReminderEnabled: Bool {
        get {
            let standard = UserDefaults.standard
            return standard.bool(forKey: "taskReminderEnabled")
        }
        set {
            if newValue == taskReminderEnabled {
                return
            }
            
            if newValue == false {
                self.clearAllTaskNotifications()
            }
            let standard = UserDefaults.standard
            standard.set(newValue, forKey: "taskReminderEnabled")
        }
    }
    
    var generalMessage: String {
        get {
            let standard = UserDefaults.standard
            return standard.string(forKey: "generalMessage") ?? ""
        }
        set {
            if newValue == generalMessage {
                return
            }
            
            let standard = UserDefaults.standard
            standard.set(newValue, forKey: "generalMessage")
        }
    }
    
    var generalDate: Date {
        get {
            let standard = UserDefaults.standard
            let dateInterval = standard.double(forKey: "generalDate")
            if dateInterval == 0 {
                return Date()
            }
            return Date(timeIntervalSince1970: dateInterval)
        }
        set {
            let standard = UserDefaults.standard
            standard.set(newValue.timeIntervalSince1970, forKey: "generalDate")
        }
    }
    
    func setNotification(for task: DailyTask) {
        guard task.name != nil, task.id != nil, task.startedAt != nil else { return }

        let date = task.startedAt.minus(minutes: UInt(self.taskTimeReminder))
        setNotification(with: task.id, name: task.name, time: date, content: "Your task - \(task.name!) is almost time out. \(taskTimeReminder) mins are remainning.", isRepeat: false)
    }
    
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
    
    func clearAllTaskNotifications() {
        LJNotificationScheduler.sharedInstance.cancelAlllNotifications()
        if generalReminderEnabled {
            self.setNotification(with: "GENERAL", name: "Reminder", time: generalDate, content: generalMessage, isRepeat: true)
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
            if Manager.shared.currentUser != nil {
                let identifier = response.notification.request.identifier
                if identifier == "GENERAL" {
                    Manager.shared.showProgrammeList()
                }
            }
            // Do something
            completionHandler()
        default:
            completionHandler()
        }
    }
}
