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
    var traitPoints = [Int]()
    var boostPoint: Int!
    
//Working Properties
    var startTime: Date!
    var traitPointsArchived = [Int]()
    
    func progress() -> CGFloat {
        var tpSum: CGFloat = 0
        for i in self.traitPoints {
            tpSum += CGFloat(i)
        }
        
        if tpSum == 0 {
            return 0
        }
        
        var tpArchived: CGFloat = 0
        for i in self.traitPointsArchived {
            tpArchived += CGFloat(i)
        }
        
        return tpArchived/tpSum * 100
    }
    
    static func fromDict(dict: [String: String]) -> DailyTask {
        let task = DailyTask()
        task.name = dict["name"]
        task.shortName = dict["shortName"]
        task.longDescription = dict["longDescription"]
        task.advice = dict["advice"]
        task.difficultRate = Int(dict["difficultRate"]!)
        task.dependency = dict["dependency"]!.boolValue
        task.traitPoints = [2,5,4,3,1,2,3]
        task.traitPointsArchived = [1,2,1,0,1,1,1]
        let date = Date().minus(days: 1)
        task.startTime = Date.parse("2017-\(String(format: "%.2d", date.month))-\(String(format: "%.2d", date.day)) \(arc4random_uniform(13)+10):00")
        return task
    }
}
