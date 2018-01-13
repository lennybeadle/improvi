//
//  DailyTask.swift
//  ImprovI
//
//  Created by Macmini on 1/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class DailyTask: ImprovIObject {
//Initial Properties
    var name: String!
    var shortName: String!
    var longDescription: String!
    var advice: String!
    var difficultRate: Int!
    var dependency: Bool!
    var traitPoints = [TraitPoint]()
    var boostPoint: Int!
    var startedAt: Date!
    var status: Status = .normal
    var unlocked: Bool = false
    
    var progress: CGFloat {
        if self.status == .ongoing {
            if let startDate = self.startedAt {
                var distance = Date.minutesBetween(date1: Date(), date2: startDate.plus(days: 1))
                if distance < 0 {
                    self.status = .timeover
                    return 0
                }
                else {
                    distance = 1440 - distance
                    return CGFloat(distance)/1440.0 * 100.0
                }
            }
        }
        else if self.status == .completed {
            return 100
        }
        return 0
    }
    
    var timeString: String! {
        if self.status == .ongoing {
            if let startDate = self.startedAt {
                let distance = Date.minutesBetween(date1: Date(), date2: startDate.plus(days: 1))
                if distance < 0 {
                    return "Time over!"
                }
                else {
                    return "Time remaining: \(distance/60) hour(s) \(distance%60) min(s)"
                }
            }
        }
        else if self.status == .completed {
            return "Completed"
        }
        else if self.status == .timeover {
            return "Time over"
        }
        return "Not yet started"
    }
    
    static func from(dict: [String: Any]) -> DailyTask {
        let task = DailyTask()
        task.data = dict
        
        if dict["id"] != nil {
            task.id = "\(dict["id"]!)"
        }
        
        if dict["name"] != nil {
            task.name = "\(dict["name"]!)"
        }
        
        if dict["description"] != nil {
            task.longDescription = "\(dict["description"]!)"
        }
        
        if dict["advice"] != nil {
            task.advice = "\(dict["advice"]!)"
        }
        
        if dict["rate"] != nil {
            task.difficultRate = "\(dict["rate"]!)".intValue
        }
        
        if dict["dependent"] != nil {
            task.dependency = "\(dict["dependent"]!)".boolValue
        }
        
        if dict["ixp"] != nil {
            task.boostPoint = "\(dict["ixp"]!)".intValue
        }

        if let traits = dict["trait"] as? [Any] {
            task.traitPoints = traits.map{TraitPoint.from(dict: ($0 as! [String: Any]))}
        }
        return task
    }
    
    var totalTrait: CGFloat {
        var sum: CGFloat = 0
        for trait in self.traitPoints {
            sum += trait.value
        }
        return sum
    }
}
