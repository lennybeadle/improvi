//
//  Programme.swift
//  ImprovI
//
//  Created by Macmini on 1/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

public enum Status: Int {
    case normal = -1
    case ongoing = 0
    case timeover = 1
    case completed = 2
}

class Programme: ImprovIObject {
    var name: String!
    var progress: CGFloat! = 0
    var tasks = [DailyTask]()
    var startTime: Date!
    var status: Status = .normal
    var availableTasks = [DailyTask]()
    
    var type: String {
        if self.name != nil {
            let components = self.name.components(separatedBy: "-")
            if components.count > 1 {
                let trait = components[1]
                if trait == "Fitness" {
                    return "Health"
                }
                else if trait == "Self" {
                    return "Concienseness"
                }
                return trait
            }
        }
        return ""
    }
    
    init(id: String, name: String) {
        super.init(id: id)
        self.name = name
    }
    
    init() {
        super.init()
        self.name = ""
    }
    
    static func from(dict: [String: Any]) -> Programme {
        let programme = Programme()

        programme.id = "\(dict["id"]!)"
        programme.name = "\(dict["name"]!)"

        if dict["progress"] != nil {
            programme.progress = "\(dict["progress"]!)".floatValue
        }
        
        if let date = dict["start_time"] as? Double {
            programme.startTime = Date(timeIntervalSince1970: date)// Date.parse(date, format: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let status = dict["status"] as? String {
            if status == "registered" {
                programme.status = .ongoing
            }
            else if status == "unregistered" {
                programme.status = .normal
            }
        }
        
        if let tasks = dict["tasks"] as? [Any] {
            programme.tasks = tasks.map{DailyTask.from(dict: ($0 as! [String: Any]))}
        }
        
        programme.update()
        return programme
    }
    
    func approachTasks(dailyTasks: [DailyTask]) {
        for task in dailyTasks {
            self.approachTask(dailyTask: task)
        }
    }
    
    func approachTask(dailyTask: DailyTask) {
        for task in self.tasks{
            if dailyTask.id == task.id
            {
                task.status = dailyTask.status
            }
        }
    }
    
    func reset() {
        self.resetTaskStatus()
        self.update()
    }
    
    func update() {
        var totalPoints: CGFloat = 0
        var currentPoints: CGFloat = 0
        for task in self.tasks {
            totalPoints += task.totalTrait
            if task.status == .completed {
                currentPoints += task.totalTrait
            }
        }
        
        self.progress = (totalPoints == 0.0 ? 0 : currentPoints / totalPoints * 100)
        if self.progress == 100 {
            self.status = .completed
        }
        else {
            if self.startTime != nil {
                let distance = Date.dateBetween(date1: self.startTime, date2: Date())
                if distance.day >= 1 {
                    self.status = .timeover
                }
            }
        }
        
        self.availableTasks.removeAll()
        if self.status == .normal {
            self.availableTasks.append(contentsOf: self.tasks)
        }
        else {
            for task in self.tasks {
                if task.status == .normal {
                    continue
                }
                availableTasks.append(task)
            }
        }
    }
    
    func index(of task: DailyTask) -> Int {
        let count = self.tasks.count
        for i in 0..<count {
            if self.tasks[i].id == task.id {
                return i
            }
        }
        return -1
    }
    
    func resetTaskStatus() {
        self.status = .normal
        self.startTime = nil
        for task in self.tasks {
            task.status = .normal
        }
    }
    
    var timeString: String {
        if self.startTime == nil {
            return "Not yet started"
        }
        else {
            var distance = Date.minutesBetween(date1: self.startTime, date2: Date())
            
            if distance >= 1440 {
                if self.progress >= 100 {
                    return "Completed"
                }
                else {
                    return "Time over!"
                }
            }
            else {
                distance = 1440 - distance
                return "Time remaining: \(distance/60) hour(s) \(distance%60) min(s)"
            }
        }
    }
    
    var timeProgress: CGFloat {
        if self.startTime == nil {
            return 0
        }
        else {
            let distance = Date.minutesBetween(date1: self.startTime, date2: Date())
            if distance >= 1440 {
                return 100
            }
            else {
                return CGFloat(CGFloat(distance)/1440.0*100.0)
            }
        }
    }
    
    var newTasksAvailable: Bool {
        if self.startTime == nil {
            return false
        }
        
        let minutes = Date.minutesBetween(date1: self.startTime, date2: Date())
        if minutes > 1440 {
            return true
        }
        return false
    }
}
 
