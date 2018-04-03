//
//  ReminderViewController.swift
//  ImprovI
//
//  Created by Macmini on 2/5/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

class ReminderViewController: BaseViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtReminder: SpringTextField!
    @IBOutlet weak var sliderTaskReminder: UISlider!
    @IBOutlet weak var lblTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.shared.getNotificationInfo(with: "GENERAL") { (date, title, body) in
            if let date = date {
                self.datePicker.date = date
                self.txtReminder.text = body
            }
        }
    }

    @IBAction func onSave(_ sender: Any) {
        var content = txtReminder.text!
        if content.count == 0 {
            content = "Please check your task progress"
        }
        NotificationManager.shared.setNotification(with: "GENERAL", name: "Reminder", time: datePicker.date, content: content, isRepeat: true)
        _  = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onChangeSlider(_ sender: Any) {
        let time = Int(sliderTaskReminder.value)
        if time > 1 {
            lblTime.text = "\(time) mins"
        }
        else {
            lblTime.text = "\(time) min"
        }
    }
    
    @IBAction func onSaveTaskReminder(_ sender: Any) {
        NotificationManager.shared.taskTimeReminder = Int(sliderTaskReminder.value)
    }
}
