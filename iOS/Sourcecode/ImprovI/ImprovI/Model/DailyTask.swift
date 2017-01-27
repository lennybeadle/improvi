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
}
