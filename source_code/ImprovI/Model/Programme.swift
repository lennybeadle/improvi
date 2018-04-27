//
//  Programme.swift
//  ImprovI
//
//  Created by Macmini on 1/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
public enum Status: Int {
    case locked = -1
    case normal = 0
    case ongoing = 1
    case timeover = 2
    case completed = 3
}

class Programme: ImprovIObject {
    var name: String!

    var tasks = [DailyTask]()
    var taskIds = [String]()
    
    var unlocked: Bool = false
    var needed_feather: Int = 0
    
    var status: Status = .normal

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
    
    var countOfTimeOverredTask: Int {
        var count: Int = 0
        for task in tasks {
            if task.status == .timeover {
                count = count + 1
            }
        }
        return count
    }
    
    var countOfWorkingTasks: Int {
        var count: Int = 0
        for task in tasks {
            if task.status == .ongoing {
                count = count + 1
            }
        }
        return count
    }
    
    var countOfCompletedTasks: Int {
        var count: Int = 0
        for task in tasks {
            if task.completedCount > 0 {
                count = count + 1
            }
        }
        return count
    }

    var progress: CGFloat {
        if self.tasks.count == 0 {
            return 0
        }
        return CGFloat(self.countOfCompletedTasks) / CGFloat(self.tasks.count) * 100.0
    }
    
    var lastTask: DailyTask? {
        if tasks.count == 0 {
            return nil
        }
        
        var retTask: DailyTask? = tasks[0]
        for task in tasks {
            if retTask?.startedAt == nil {
                retTask = task
                continue
            }
            
            if task.startedAt != nil, task.startedAt > retTask!.startedAt {
                retTask = task
            }
        }
        if retTask?.startedAt == nil {
            return nil
        }
        
        return retTask
    }
    
    var timeProgress: CGFloat {
        if let task = self.lastTask, task.status == .ongoing {
            let distance = Date.minutesBetween(date1: task.startedAt, date2: Date())
            if distance >= 1440 {
                if self.progress >= 100 {
                    task.status = .completed
                    return 100
                }
                else {
                    task.status = .timeover
                    return 200
                }
            }
            else {
                return CGFloat(distance)/1440.0 * 100.0
            }
        }
        return 0
    }
    
    var timeString: String {
        if self.progress >= 100 {
            return "Completed"
        }
        
        if self.countOfTimeOverredTask > 0 {
            return "Time over"
        }
        
        if let task = self.lastTask, task.status == .ongoing {
            var distance = Date.minutesBetween(date1: task.startedAt, date2: Date())
            if distance >= 1440 {
                if self.progress >= 100 {
                    task.status = .completed
                    return "Completed"
                }
                else {
                    task.status = .timeover
                    return "Time over!"
                }
            }
            else {
                distance = 1440 - distance
                return "Time remaining: \(distance/60) hour(s) \(distance%60) min(s)"
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

        if dict["needed_feather"] != nil {
            programme.needed_feather = "\(dict["needed_feather"]!)".intValue
        }
        
        if dict["unlocked"] != nil {
            programme.unlocked = "\(dict["unlocked"]!)".boolValue
        }
        
        if let tasks = dict["tasks"] as? [String] {
            programme.taskIds = tasks
        }

        return programme
    }
    
    func getPrepared(with tasks: [DailyTask]) {
        self.tasks = taskIds.map { (taskId) -> DailyTask in
            for task in tasks {
                if taskId == task.id {
                    task.status = .locked
                    return task
                }
            }
            let dailyTask = DailyTask()
            dailyTask.id = taskId
            return dailyTask
        }
    }
    
    func resetTaskStatus() {
        for task in self.tasks {
            task.status = .locked
            task.startedAt = nil
        }
    }
    
    func updateTaskStatus(taskId: String, status: Int, startedAt: Date?, endedAt: Date?, completedCount: Int = 0) {
        for task in self.tasks {
            if task.id == taskId {
                task.status = Status(rawValue: status)!
                task.startedAt = startedAt
                task.endedAt = endedAt
                task.unlocked = true
                task.completedCount = completedCount
                if task.status == .ongoing {
                    NotificationManager.shared.setNotification(for: task)
                }
                return
            }
        }
    }
    
    func applyTaskStatus(with taskStatus: [Any]) {
        self.resetTaskStatus()
        for status in taskStatus {
            let dict = status as! [String: Any]
            let startedAt = Date(timeIntervalSince1970: dict["started_at"] as! TimeInterval)
            let endedAt = Date(timeIntervalSince1970: dict["ended_at"] as! TimeInterval)
            self.updateTaskStatus(taskId: dict["task_id"] as! String,
                                  status: (dict["status"] as! String).intValue,
                                  startedAt: startedAt,
                                  endedAt: endedAt,
                                  completedCount: (dict["completed_count"] as! String).intValue)
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
    
    func programTasks(of status: Status) -> [DailyTask] {
        var programTasks = [DailyTask]()
        for task in self.tasks {
            if task.status == status {
                programTasks.append(task)
            }
        }
        return programTasks
    }
    
    func programTasks(except status: Status) -> [DailyTask]{
        var programTasks = [DailyTask]()
        for task in self.tasks {
            if task.status != status {
                programTasks.append(task)
            }
        }
        return programTasks
    }
}
 
