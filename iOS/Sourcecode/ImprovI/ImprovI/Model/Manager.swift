//
//  Manager.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class Manager {
    static let sharedInstance: Manager = Manager()
    
    var allProgrammes = [Programme]()
    var currentUser: User!
    
    init() {
        currentUser = User()
//        currentUser.addProgramme(Programme(id: "1", name: "Improvi Fitness"))
//        currentUser.addProgramme(Programme(id: "2", name: "Improvi Health"))
//        currentUser.addProgramme(Programme(id: "3", name: "Improvi Body"))
//        currentUser.addProgramme(Programme(id: "4", name: "Improvi Leg"))
//        currentUser.addProgramme(Programme(id: "0", name: "Improvi Test"))
        self.allProgrammes.append(Programme(id: "1", name: "Improvi Fitness"))
        self.allProgrammes.append(Programme(id: "2", name: "Improvi Health"))
        self.allProgrammes.append(Programme(id: "3", name: "Improvi Body"))
        self.allProgrammes.append(Programme(id: "4", name: "Improvi Leg"))
        self.allProgrammes.append(Programme(id: "5", name: "Improvi Arms"))
    }
    
    func initUISettings() {
        UINavigationBar.appearance().barTintColor = Constant.UI.foreColor
        UINavigationBar.appearance().tintColor = Constant.UI.backColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Constant.UI.backColor]
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
