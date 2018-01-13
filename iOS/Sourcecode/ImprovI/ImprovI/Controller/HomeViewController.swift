//
//  HomeViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Manager.sharedInstance.allProgrammes.isEmpty {
            self.loadProgrammes()
        }
    }
    
    func loadProgrammes() {
        SVProgressHUD.show(withStatus: Constant.Keyword.loading)
        APIManager.getPrograms(userId: Manager.sharedInstance.currentUser.id) { (programmes) in
            SVProgressHUD.dismiss()
            if let programs = programmes {
                Manager.sharedInstance.allProgrammes = programs
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sid_programmes" {
            if Manager.sharedInstance.allProgrammes.count == 0 {
                self.alert(message: "Loading programmes... Please wait.")
                return false
            }
        }
        return true
    }
}
