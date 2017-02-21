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

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.sharedInstance.getNotificationInfo(with: "GENERAL") { (date, title, body) in
            if let date = date {
                self.datePicker.date = date
                self.txtReminder.text = body
            }
        }
    }

    @IBAction func onSave(_ sender: Any) {
        var content = txtReminder.text!
        if content.characters.count == 0 {
            content = "Please check your task progress"
        }
        NotificationManager.sharedInstance.setNotification(with: "GENERAL", name: "Reminder", time: datePicker.date, content: content, isRepeat: true)
        _  = self.navigationController?.popViewController(animated: true)
    }
}
