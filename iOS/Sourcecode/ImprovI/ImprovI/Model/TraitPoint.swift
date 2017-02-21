//
//  TraitPoint.swift
//  ImprovI
//
//  Created by Macmini on 2/8/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class TraitPoint: ImprovIObject {
    var name: String!
    var value: CGFloat!
    
    static func from(dict: [String: Any]) -> TraitPoint{
        let traitPoint = TraitPoint()
        if let value = dict["id"]{
            traitPoint.id = "\(value)"
        }
        if let value = dict["name"]{
            traitPoint.name = "\(value)"
        }
        if let value = dict["point"]{
            traitPoint.value = "\(value)".floatValue
        }
        return traitPoint
    }
}
