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
        APIManager.getProgramme(userId: Manager.sharedInstance.currentUser.id) { (programmes) in
            SVProgressHUD.dismiss()
            Manager.sharedInstance.approachProgrammes(programmes: programmes)
        }
    }
    
    
}
