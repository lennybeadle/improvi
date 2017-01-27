//
//  ProgrammeDetailViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/28/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ProgrammeDetailViewController: BaseViewController {
    var programme: Programme!
    
    @IBOutlet weak var vwInfo: UIView!
    @IBOutlet weak var vwDailyTask: UIView!
    @IBOutlet weak var progressBar: LinearProgressView!
    @IBOutlet weak var lblNumberOfWeek: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwInfo.layer.cornerRadius = 6
        self.vwInfo.layer.masksToBounds = false
            
        self.vwInfo.layer.shadowColor = UIColor.gray.cgColor
        self.vwInfo.layer.shadowOpacity = 0.5
        self.vwInfo.layer.shadowRadius = 2
        self.vwInfo.layer.shadowOffset = CGSize(width: 0, height: 2)

        
        self.vwDailyTask.layer.cornerRadius = 6
        self.vwDailyTask.layer.masksToBounds = true
        
        if self.programme != nil {
            self.title = programme.name
            progressBar.progressValue = CGFloat(self.programme.progress)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
