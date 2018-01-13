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
    var feathers: Int!
    
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
}
