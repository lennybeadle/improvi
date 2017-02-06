//
//  NotificationManager.swift
//  ImprovI
//
//  Created by Macmini on 2/5/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ImproviNotification {
    var time: Date!
    var text: String!
    var name: String!
    var isRepeat: Bool!
    
    init() {
        
    }
    
    init(name: String, time: Date, content: String, isRepeat: Bool) {
        self.name = name
        self.time = time
        self.text = content
        self.isRepeat = isRepeat
    }
    
    func data() -> [String: Any] {
        return ["name": self.name, "time": self.time, "content": self.text, "isRepeat": isRepeat]
    }
    
    static func notification(from data: Any?) -> ImproviNotification? {
        if let dict = data as? [String: Any] {
            let notification = ImproviNotification()
            if let name = dict["name"] as? String {
                notification.name = name
            }
            if let time = dict["time"] as? Date {
                notification.time = time
            }
            if let text = dict["content"] as? String {
                notification.text = text
            }
            if let isRepeat = dict["isRepeat"] as? Bool {
                notification.isRepeat = isRepeat
            }
            return notification
        }
        return nil
    }
}

class NotificationManager {
    static let sharedInstance = NotificationManager()
    var notifications = [ImproviNotification]()
    
    init() {
        if let dictArray = UserDefaults.standard.value(forKey: "Notifications") as? [Any] {
            for dict in dictArray {
                if let notification = ImproviNotification.notification(from: dict) {
                    self.notifications.append(notification)
                }
            }
        }
    }
    
    func setNotification(with name: String, time: Date, content: String, isRepeat: Bool) {
        for notification in self.notifications {
            if notification.name == name {
                notification.time = time
                notification.text = content
                notification.isRepeat = isRepeat
                saveNotifications()
                return
            }
        }
        
        notifications.append(ImproviNotification(name: name, time: time, content: content, isRepeat: isRepeat))
        saveNotifications()
    }
    
    func saveNotifications() {
        var array = [Any]()
        for notification in self.notifications {
            array.append(notification.data())
        }
        UserDefaults.standard.setValue(array, forKey: "Notifications")
        UserDefaults.standard.synchronize()
    }

    func getNotification( name: String) -> ImproviNotification? {
        for notification in self.notifications {
            if notification.name == name {
                return notification
            }
        }
        return nil
    }
}
