//
//  DailyTaskViewController.swift
//  ImprovI
//
//  Created by Macmini on 12/27/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

protocol DailyTaskViewDelegate {
    func taskStatusChanged(_ task: DailyTask);
}

class DailyTaskViewController: UIViewController {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var txtContainer: UIView!
    
    weak var dailyTask: DailyTask!
    var delegate: DailyTaskViewDelegate!
    var pageIndex: Int = 0
    var count: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblDate.layer.cornerRadius = self.lblDate.frame.height/2
        self.lblTitle.layer.cornerRadius = self.lblTitle.frame.height/2
        
        txtContainer.layer.cornerRadius = 10
        self.txtContainer.layer.shadowColor = UIColor.gray.cgColor
        self.txtContainer.layer.shadowOpacity = 0.3
        self.txtContainer.layer.shadowRadius = 5
        self.txtContainer.layer.shadowOffset = CGSize(width: 1, height: 4)

        self.lblTitle.text = "      " + (self.dailyTask.name ?? "") + "          "
        self.lblTitle.sizeToFit()
        self.lblDescription.text = dailyTask.longDescription
        self.updateWithStatus()
        self.updateIndex(index: pageIndex, count: count)
    }
    
    func updateDate(date: Date) {
        self.lblDate.text = "    " + date.dateString
    }
    
    func updateIndex(index: Int, count: Int) {
        self.lblDate.text = "    " + "\(index+1) out of \(count)"//"    " + date.dateString
    }

    func updateWithDailyTask(task: DailyTask) {
        self.dailyTask = task
    }
    
    func updateWithStatus() {
        if self.dailyTask.status == .ongoing {
            self.btnStatus.isEnabled = true
            self.btnStatus.setTitleColor(Constant.UI.foreColorLight, for: .normal)
            self.btnStatus.setTitle("Complete", for: .normal)
        }
        else if self.dailyTask.status == .normal{
            self.btnStatus.isEnabled = true
            self.btnStatus.setTitleColor(Constant.UI.foreColor, for: .normal)
            self.btnStatus.setTitle("Start", for: .normal)
        }
        else if self.dailyTask.status == .timeover {
            self.btnStatus.isEnabled = true
            self.btnStatus.setTitleColor(Constant.UI.foreColorHighlight, for: .normal)
            self.btnStatus.setTitle("TimeOver", for: .normal)
        }
        else if self.dailyTask.status == .completed {
            self.btnStatus.isEnabled = false
            self.btnStatus.setTitleColor(Constant.UI.foreColorLight, for: .normal)
            self.btnStatus.setTitle("Completed", for: .normal)
        }
    }
    
    @IBAction func onComplete(_ sender: UIButton) {
        if self.dailyTask.status == .ongoing {
            self.alert(message: "Are you going to complete the task now?", title: "", options: "Yes", "No", completion: { (option) in
                if option == 0 {// Yes
                    self.setDailyTaskStatus(status: .completed)
                }
            })
        }
        else if self.dailyTask.status == .normal{
            self.alert(message: "Are you going to start the task now?", title: "", options: "Yes", "No", completion: { (option) in
                if option == 0 {// Yes
                    self.setDailyTaskStatus(status: .ongoing)
                }
            })
        }
        else if self.dailyTask.status == .timeover {
            self.alert(message: "This task has been timeover. Are you going to complete now?", title: "", options: "Yes", "No", completion: { (option) in
                if option == 0 {// Yes
                    self.setDailyTaskStatus(status: .completed)
                }
            })
        }
    }
    
    func setDailyTaskStatus(status: Status) {
        if self.dailyTask.status == status {
            return
        }
        
        self.dailyTask.startedAt = Date()
        self.dailyTask.status = status
        self.updateWithStatus()
        if self.delegate != nil {
            self.delegate.taskStatusChanged(self.dailyTask)
        }
    }
}
