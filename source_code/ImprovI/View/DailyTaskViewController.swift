//
//  DailyTaskViewController.swift
//  ImprovI
//
//  Created by Macmini on 12/27/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

let waitingHours: UInt = 5

protocol DailyTaskViewDelegate {
    func taskStatusChanged(_ task: DailyTask, to: Status, completion: ((Bool)->Void)?)
    func unlockTask(_ task: DailyTask, completion: ((Bool)->Void)?)
}

class DailyTaskViewController: BaseViewController {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var txtContainer: UIView!
    @IBOutlet weak var imgLocked: UIImageView!
    
    var isShowingDescription: Bool = true
    
    weak var dailyTask: DailyTask!
    var delegate: DailyTaskViewDelegate!
    var pageIndex: Int = 0
    var count: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        if UIManager.shared.isiPad() {
            self.lblDescription.font = UIFont.boldSystemFont(ofSize: 28)
        }
        else {
            self.lblDescription.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        self.lblDate.layer.cornerRadius = self.lblDate.frame.height/2
        self.lblTitle.layer.cornerRadius = self.lblTitle.frame.height/2
        
        txtContainer.layer.cornerRadius = 10
        txtContainer.isUserInteractionEnabled = true
        self.txtContainer.layer.shadowColor = UIColor.gray.cgColor
        self.txtContainer.layer.shadowOpacity = 0.3
        self.txtContainer.layer.shadowRadius = 5
        self.txtContainer.layer.shadowOffset = CGSize(width: 1, height: 4)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DailyTaskViewController.tapOnContainer(_:)))
        txtContainer.addGestureRecognizer(tapGesture)

        self.lblTitle.text = "      " + (self.dailyTask.name ?? "") + "          "
        self.lblTitle.sizeToFit()
        self.lblDescription.text = dailyTask.longDescription
        self.updateWithStatus()
        self.updateIndex(index: pageIndex, count: count)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TimeMachine.shared.removeObserver(self)
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
        TimeMachine.shared.removeObserver(self)
        self.lblDescription.isHidden = false
        self.imgLocked.isHidden = true
        if self.dailyTask.status == .locked {
            self.btnStatus.isEnabled = true
            self.btnStatus.setTitleColor(Constant.UI.foreColorLight, for: .normal)
            self.btnStatus.setTitle("Unlock", for: .normal)
            self.lblDescription.isHidden = true
            self.imgLocked.isHidden = false
        }
        else if self.dailyTask.status == .ongoing {
            self.btnStatus.isEnabled = true
            self.btnStatus.setTitleColor(Constant.UI.foreColorHighlight, for: .normal)
            self.btnStatus.setTitle("Complete", for: .normal)
        }
        else if self.dailyTask.status == .normal{
            if self.dailyTask.endedAt != nil {
                if self.dailyTask.endedAt.plus(hours: waitingHours) >= Date() {
                    TimeMachine.shared.addObserver(self)
                    self.btnStatus.setTitleColor(Constant.UI.foreColorHighlight, for: .normal)
                    self.timeUpdated(period: 0)
                    return
                }
            }
            
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
        if self.dailyTask.status == .locked {
            self.askUnlockWithFeather(feathers: 1, completion: { (feathers) in
                self.unlockTask(task: self.dailyTask)
            })
        }
        else if self.dailyTask.status == .ongoing {
            self.alert(message: "Are you going to complete the task now?", title: "", options: "Yes", "No", completion: { (option) in
                if option == 0 {// Yes
                    self.setDailyTaskStatus(status: .completed)
                }
            })
        }
        else if self.dailyTask.status == .normal{
            if let endedAt = self.dailyTask.endedAt, endedAt.plus(hours: waitingHours) > Date() {
                return
            }
            
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
        
        if self.delegate != nil {
            self.delegate.taskStatusChanged(self.dailyTask, to: status, completion: { (result) in
                self.updateWithStatus()
            })
        }
    }
 
    @objc func tapOnContainer (_ sender: UITapGestureRecognizer) {
        if (self.dailyTask.status == .locked) {
            self.askUnlockWithFeather(feathers: 1, completion: { (feathers) in
                self.unlockTask(task: self.dailyTask)
            })
        }
        else {
            self.txtContainer.flip(with: 0.3, repeatCount: 1, autoReverse: false)
            isShowingDescription = !isShowingDescription
            if (isShowingDescription) {
                self.lblDescription.text = self.dailyTask.longDescription
            }
            else {
                self.lblDescription.text = self.dailyTask.advice
            }
        }
    }
    
    func unlockTask(task: DailyTask) {
        if self.delegate != nil {
            self.delegate.unlockTask(self.dailyTask, completion: { (result) in
                if (result) {
                    self.updateWithStatus()
                }
            })
        }
    }
}

extension DailyTaskViewController: TimeDelegate {
    func timeUpdated(period: Double = 1.0) {
        if let endedAt = self.dailyTask.endedAt {
            let waitForSecs = endedAt.plus(hours: waitingHours).timeIntervalSince1970 - Date().timeIntervalSince1970
            if waitForSecs > 0 {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute, .second]
                formatter.unitsStyle = .abbreviated
                if let formattedString = formatter.string(from: waitForSecs) {
                    UIView.performWithoutAnimation {
                        self.btnStatus.setTitle("Wait for "+formattedString, for: .normal)
                    }
                }
            }
            else {
                self.dailyTask.status = .normal
                self.updateWithStatus()
            }
        }
    }
}
