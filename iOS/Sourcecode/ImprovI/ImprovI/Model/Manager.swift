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
    
    init() {

    }
    
    func initUISettings() {
        UINavigationBar.appearance().barTintColor = Constant.UI.foreColor
        UINavigationBar.appearance().tintColor = Constant.UI.backColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Constant.UI.backColor]
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
