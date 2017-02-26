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
    var status: Status = .normal
    
    static func from(dict: [String: Any]) -> DailyTask {
        let task = DailyTask()
        
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
            task.advice = "\(dict["advice"])"
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
        
        if let completion = dict["completed"] as? String, completion.boolValue == true{
            task.status = .completed
        }
        
        if let status = dict["status"] as? String {
            if status == "ongoing" {
                task.status = .ongoing
            }
            else if status == "normal" {
                task.status = .normal
            }
            else if status == "completed" {
                task.status = .completed
            }
            else if status == "timeover" {
                task.status = .timeover
            }
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
