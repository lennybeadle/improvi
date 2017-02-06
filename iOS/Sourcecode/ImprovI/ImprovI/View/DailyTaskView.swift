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
    @IBOutlet weak var btnStatus: UIButton!
    
    weak var dailyTask: DailyTask!
    
    override func awakeFromNib() {
        self.lblDate.layer.cornerRadius = self.lblDate.frame.height/2        
        self.lblTitle.layer.cornerRadius = self.lblTitle.frame.height/2
    }
    
    func updateWithDailyTask(task: DailyTask) {
        self.dailyTask = task
        self.lblTitle.text = "      " + task.name + "          "
        self.lblTitle.sizeToFit()
        self.lblDescription.text = task.longDescription
        self.updateWithStatus()
    }
    
    func updateDate(date: Date) {
        self.lblDate.text = "    " + date.dateString
    }
    
    func updateWithStatus() {
        self.btnStatus.isEnabled = true
        if self.dailyTask.status == .ongoing {
            self.btnStatus.isEnabled = true
            self.btnStatus.setTitleColor(Constant.UI.foreColor, for: .normal)
            self.btnStatus.setTitle("Complete", for: .normal)
        }
        else if self.dailyTask.status == .normal{
            self.btnStatus.setTitle("", for: .normal)
        }
        else if self.dailyTask.status == .timeover {
            self.btnStatus.isEnabled = true
            self.btnStatus.setTitleColor(Constant.UI.foreColorHighlight, for: .normal)
            self.btnStatus.setTitle("Complete", for: .normal)
        }
        else if self.dailyTask.status == .completed {
            self.btnStatus.setTitleColor(Constant.UI.foreColorLight, for: .normal)
            self.btnStatus.setTitle("Completed", for: .normal)
        }
    }
    
    @IBAction func onComplete(_ sender: UIButton) {
        if self.dailyTask.status == .ongoing || self.dailyTask.status == .timeover {
            //Complete the task
            self.dailyTask.status = .completed
            self.updateWithStatus()
        }
    }
}
