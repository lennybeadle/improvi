//
//  DLLocalNotifications.swift
//  DLLocalNotifications
//
//  Created by Li Jin on 2/20/17.
//  Copyright © 2017 Li Jin. All rights reserved.
//

import Foundation
import UserNotifications
import MapKit


public class LJNotificationScheduler{
    static let sharedInstance = LJNotificationScheduler()
    
    public init () {
        
        
    }
    
    public class func requestAuthrization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
        // Enable or disable features based on authorization.
        }
    }
    
    public func cancelAlllNotifications () {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    public func cancelNotification(with identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    public func cancelNotification (notification: LJNotification) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(notification.localNotificationRequest?.identifier)!])
    }
    
    private func convertToNotificationDateComponent (notification: LJNotification, repeatInterval: Repeats   ) -> DateComponents{
        var newComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: notification.fireDate!)
        
        if repeatInterval != .None {
            
            switch repeatInterval {
            case .Minute:
                newComponents = Calendar.current.dateComponents([ .second], from: notification.fireDate!)
            case .Hourly:
                newComponents = Calendar.current.dateComponents([ .minute], from: notification.fireDate!)
            case .Daily:
                newComponents = Calendar.current.dateComponents([.hour, .minute], from: notification.fireDate!)
            case .Weekly:
                newComponents = Calendar.current.dateComponents([.hour, .minute, .weekday], from: notification.fireDate!)
            case .Monthly:
                newComponents = Calendar.current.dateComponents([.hour, .minute, .day], from: notification.fireDate!)
            case .Yearly:
                newComponents = Calendar.current.dateComponents([.hour, .minute, .day, .month], from: notification.fireDate!)
            default:
                break
            }
        }
        
        
        
        return newComponents
    }
    
    
    public func scheduleNotification ( notification: LJNotification) -> String? {
        
        
        if notification.scheduled {
            return nil
        }
        else {
            var trigger: UNNotificationTrigger
            
            if (notification.region != nil) {
                trigger = UNLocationNotificationTrigger(region: notification.region!, repeats: false)
                
            } else{
                
                trigger = UNCalendarNotificationTrigger(dateMatching: convertToNotificationDateComponent(notification: notification, repeatInterval: notification.repeatInterval), repeats: notification.repeats)
            }
            let content = UNMutableNotificationContent()
            
            content.title = notification.alertTitle!
            
            content.body = notification.alertBody!
            
            content.sound = (notification.soundName == nil) ? UNNotificationSound.default() : UNNotificationSound.init(named: notification.soundName!)
            
            if !(notification.attachments == nil){ content.attachments = notification.attachments! }
            
            if !(notification.launchImageName == nil){ content.launchImageName = notification.launchImageName! }
            
            if !(notification.category == nil){ content.categoryIdentifier = notification.category! }
            
            notification.localNotificationRequest = UNNotificationRequest(identifier: notification.identifier!, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(notification.localNotificationRequest!, withCompletionHandler: {(error) in print ("completed") } )
            
            notification.scheduled = true
            
            
            
        }
        
        return notification.identifier
        
        
        
    }
    
    // You have to manually keep in mind ios 64 notification limit
    
    public func repeatsFromToDate (identifier:String, alertTitle:String, alertBody: String, fromDate: Date, toDate: Date, interval: Double, repeats: Repeats) {
        
        
        
        
        let notification = LJNotification(identifier: identifier, alertTitle: alertTitle, alertBody: alertBody, date: fromDate, repeats: repeats)
        
        // Create multiple Notifications
        
        let _ = self.scheduleNotification(notification: notification)
        let intervalDifference = Int( toDate.timeIntervalSince(fromDate) / interval )
        
        var nextDate = fromDate
        
        for i in 0..<intervalDifference {
            
            // Next notification Date
            
            nextDate = nextDate.addingTimeInterval(interval)
            
            // create notification
            
            let identifier = identifier + String(i + 1)
            
            let notification = LJNotification(identifier: identifier, alertTitle: alertTitle, alertBody: alertBody, date: nextDate, repeats: repeats)
            
            let _ = self.scheduleNotification(notification: notification)
        }
        
        
    }
    
    
    public func scheduleCategories(categories:[LJCategory]) {
        
        var categories1 = Set<UNNotificationCategory>()
        
        for x in categories {
            
            categories1.insert(x.categoryInstance!)
        }
        UNUserNotificationCenter.current().setNotificationCategories(categories1)
        
        
        
    }
    
    
    
    
    
}

// Repeating Interval Times

public enum Repeats: String {
    case None, Minute, Hourly , Daily, Weekly , Monthly, Yearly
}


// A wrapper class for creating a Category

public class LJCategory  {
    
    private var actions:[UNNotificationAction]?
    internal var categoryInstance:UNNotificationCategory?
    var identifier:String
    
    
    public init (categoryIdentifier:String) {
        
        identifier = categoryIdentifier
        
    }
    
    public func addActionButton(identifier:String?, title:String?) {
        
        let action = UNNotificationAction(identifier: identifier!, title: title!, options: [])
        actions?.append(action)
        categoryInstance = UNNotificationCategory(identifier: self.identifier, actions: self.actions!, intentIdentifiers: [], options: [])
        
    }
    
    
    
    
    
}




// A wrapper class for creating a User Notification

public class LJNotification {
    
    internal var localNotificationRequest: UNNotificationRequest?
    
    var repeatInterval: Repeats = .None
    
    var alertBody: String?
    
    var alertTitle: String?
    
    var soundName: String?
    
    var fireDate: Date?
    
    var repeats:Bool = false
    
    var scheduled: Bool = false
    
    var identifier:String?
    
    var attachments:[UNNotificationAttachment]?
    
    var launchImageName: String?
    
    var category:String?
    
    var region:CLRegion?
    
    public init (identifier:String, alertTitle:String, alertBody: String, date: Date?, repeats: Repeats ) {
        
        self.alertBody = alertBody
        self.alertTitle = alertTitle
        self.fireDate = date
        self.repeatInterval = repeats
        self.identifier = identifier
        if (repeats == .None) {
            self.repeats = false
        } else {
            self.repeats = true
        }
        
        
        
        
    }
    
    public init (identifier:String, alertTitle:String, alertBody: String, date: Date?, repeats: Repeats, soundName: String ) {
        
        self.alertBody = alertBody
        self.alertTitle = alertTitle
        self.fireDate = date
        self.repeatInterval = repeats
        self.soundName = soundName
        self.identifier = identifier
        
        if (repeats == .None) {
            self.repeats = false
        } else {
            self.repeats = true
        }
        
    }
    
    // Region based notification
    // Default notifyOnExit is false and notifyOnEntry is true
    
    public init (identifier:String, alertTitle:String, alertBody: String, region: CLRegion? ) {
        
        self.alertBody = alertBody
        self.alertTitle = alertTitle
        self.identifier = identifier
        region?.notifyOnExit = false
        region?.notifyOnEntry = true
        self.region = region
        
        
    }
    
    
}

