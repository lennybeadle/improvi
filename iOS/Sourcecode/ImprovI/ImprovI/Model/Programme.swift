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
    }
}
