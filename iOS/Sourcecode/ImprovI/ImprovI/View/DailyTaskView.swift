//
//  DailyTaskView.swift
//  ImprovI
//
//  Created by Macmini on 2/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

class DailyTaskView: SpringView {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var titleWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.lblDate.layer.cornerRadius = self.lblDate.frame.height/2        
        self.lblTitle.layer.cornerRadius = self.lblTitle.frame.height/2
    }
    
    func updateWithDailyTask(task: DailyTask) {
        self.lblTitle.text = "      " + task.name + "          "
        self.lblTitle.sizeToFit()
        self.lblDescription.text = task.longDescription
    }
    
    func updateDate(date: Date) {
        self.lblDate.text = "    " + date.dateString
    }
}
