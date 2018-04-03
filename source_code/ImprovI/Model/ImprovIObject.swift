//
//  ImprovIObject.swift
//  ImprovI
//
//  Created by Macmini on 1/27/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ImprovIObject: Equatable{
    static func == (lhs: ImprovIObject, rhs: ImprovIObject) -> Bool {
        return lhs.id == rhs.id
    }
    
    var data: [String: Any]!
    var id: String! = ""
    var userData: String!
    
    var collapsed: Bool = false

    init(id: String = "0") {
        self.id = id
    }
}
