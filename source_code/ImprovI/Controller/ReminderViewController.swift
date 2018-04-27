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
    
    @IBOutlet weak var btnSaveGeneral: SpringButton!
    @IBOutlet weak var btnSaveTask: SpringButton!
    @IBOutlet weak var switchGeneralReminder: UISwitch!
    @IBOutlet weak var switchTaskReminder: UISwitch!
    
    var generalReminderEnabled: Bool = false {
        didSet {
            btnSaveGeneral.isEnabled = generalReminderEnabled
            datePicker.isEnabled = generalReminderEnabled
            txtReminder.isEnabled = generalReminderEnabled
            switchGeneralReminder.isOn = generalReminderEnabled
        }
    }
    var taskReminderEnabled: Bool = false {
        didSet {
            btnSaveTask.isEnabled = taskReminderEnabled
            sliderTaskReminder.isEnabled = taskReminderEnabled
            lblTime.isEnabled = taskReminderEnabled
            switchTaskReminder.isOn = taskReminderEnabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.shared.getNotificationInfo(with: "GENERAL") { (date, title, body) in
            if let date = date {
                DispatchQueue.main.async {
                    self.datePicker.date = date
                    self.txtReminder.text = body
                }
            }
        }
     
        self.sliderTaskReminder.value = Float(NotificationManager.shared.taskTimeReminder)
        onChangeSlider(self.sliderTaskReminder)
        self.generalReminderEnabled = NotificationManager.shared.generalReminderEnabled
        self.taskReminderEnabled = NotificationManager.shared.taskReminderEnabled
    }

    @IBAction func onSave(_ sender: Any) {
        var content = txtReminder.text!
        if content.count == 0 {
            content = "Please check your task progress"
            NotificationManager.shared.generalMessage = content
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
    
    @IBAction func onGeneralReminderSwitch(_ sender: UISwitch) {
        NotificationManager.shared.generalReminderEnabled = sender.isOn
        self.generalReminderEnabled = sender.isOn
    }
    
    @IBAction func onTaskReminderSwitch(_ sender: UISwitch) {
        NotificationManager.shared.taskReminderEnabled = sender.isOn
        self.taskReminderEnabled = sender.isOn
    }
    
}
