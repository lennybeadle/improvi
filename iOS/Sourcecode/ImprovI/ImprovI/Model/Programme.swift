//
//  Programme.swift
//  ImprovI
//
//  Created by Macmini on 1/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class Programme: ImprovIObject {
    var name: String!
    var progress: Float! = 0
    var tasks = [DailyTask]()
    
    init(id: String, name: String) {
        super.init(id: id)
        self.name = name
        self.progress = Float(arc4random_uniform(100))
        
//This is a template code
//        task.name = dict["name"]
//        task.shortName = dict["shortName"]
//        task.longDescription = dict["longDescription"]
//        task.advice = dict["advice"]
//        task.difficultRate = Int(dict["difficultRate"]!)
//        task.dependency = dict["dependency"]!.boolValue
        self.tasks.append(
        DailyTask.fromDict(dict: ["name": "Electronics Ban", "shortName":"elec_ban", "longDescription": "Don't let anyone in the household use electronics for at least 30 minutes", "advice": "30 minutes can fly by when you are on your phone.", "difficultRate": "6", "dependency": "true"]))
        
        self.tasks.append(
        DailyTask.fromDict(dict: ["name": "Loving Yourself", "shortName":"elec_ban", "longDescription": "Don't let anyone in the household use electronics for at least 30 minutes", "advice": "30 minutes can fly by when you are on your phone.", "difficultRate": "6", "dependency": "true"]))
        
        self.tasks.append(
        DailyTask.fromDict(dict: ["name": "Be grateful", "shortName":"elec_ban", "longDescription": "Don't let anyone in the household use electronics for at least 30 minutes", "advice": "30 minutes can fly by when you are on your phone.", "difficultRate": "6", "dependency": "true"]))
       
        self.tasks.append(
        DailyTask.fromDict(dict: ["name": "Todays plan", "shortName":"elec_ban", "longDescription": "Don't let anyone in the household use electronics for at least 30 minutes", "advice": "30 minutes can fly by when you are on your phone.", "difficultRate": "6", "dependency": "true"]))
        
        self.tasks.append(
        DailyTask.fromDict(dict: ["name": "Think why", "shortName":"elec_ban", "longDescription": "Don't let anyone in the household use electronics for at least 30 minutes", "advice": "30 minutes can fly by when you are on your phone.", "difficultRate": "6", "dependency": "true"]))
        
        self.tasks.append(
        DailyTask.fromDict(dict: ["name": "Show your love", "shortName":"elec_ban", "longDescription": "Don't let anyone in the household use electronics for at least 30 minutes", "advice": "30 minutes can fly by when you are on your phone.", "difficultRate": "6", "dependency": "true"]))
        
        self.tasks.append(
        DailyTask.fromDict(dict: ["name": "Learn something new", "shortName":"elec_ban", "longDescription": "Don't let anyone in the household use electronics for at least 30 minutes", "advice": "30 minutes can fly by when you are on your phone.", "difficultRate": "6", "dependency": "true"]))
    }
}
