//
//  User.swift
//  ImprovI
//
//  Created by Macmini on 1/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class User: ImprovIObject {
    var userName: String!
    var fullName: String!
    var imageLink: String!
    
    var programmes: [Programme]! = [Programme]()
    var totalIXP: Int!
    var tasksCompleted: Int!
    var programmesCompleted: Int!
    var traitPoints = [Int]()
    
//Working Properties
    var image: UIImage!
    
    func hasProgramme(_ programme: Programme) -> Bool{
        for prgm in self.programmes {
            if prgm.id == programme.id {
                return true
            }
        }
        return false
    }
    
    func addProgramme(_ programme: Programme) {
        for programmeObj in self.programmes {
            if programme.id == programmeObj.id {
                return
            }
        }
        self.programmes.append(programme)
    }
}
