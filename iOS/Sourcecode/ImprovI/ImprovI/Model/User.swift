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
    var emailAddress: String!
    var password: String!
    var dateJoined: Date!
    var imageLink: String!
    
    var programmes: [Programme]! = [Programme]()
    var tasksCompleted: Int!
    var programmesCompleted: Int!
    
    var traitPoints = [TraitPoint]()
    var totalIXP: Int = -1
    
//Working Properties
    var image: UIImage! {
        get{
            if let profileImageData = UserDefaults.standard.data(forKey: "profile_image") {
                return UIImage(data: profileImageData)
            }
            return nil
        }
        set{
            DispatchQueue.global(qos: .background).async {
                UserDefaults.standard.set(UIImagePNGRepresentation(newValue), forKey: "profile_image")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    var maxTraits: Int {
        var value: CGFloat = -1
        for trait in self.traitPoints {
            if trait.value > value {
                value = trait.value
            }
        }
        return Int(value)
    }
    
    var totalTP: Int {
        var value: CGFloat = 0
        for trait in self.traitPoints {
            value += trait.value
        }
        return Int(value)
    }
    
    func programmeRequireNewTask() -> Programme? {
        for programme in self.programmes {
            if programme.newTasksAvailable {
                return programme
            }
        }
        return nil
    }
    
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
    
    func programme(with programmeId: String) -> Programme? {
        for programme in self.programmes {
            if programme.id == programmeId {
                return programme
            }
        }
        return nil
    }
}
