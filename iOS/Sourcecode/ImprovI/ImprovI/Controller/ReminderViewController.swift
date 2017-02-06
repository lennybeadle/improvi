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

        if let notification = NotificationManager.sharedInstance.getNotification(name: "GENERAL") {
            datePicker.date = notification.time
        }
    }

    @IBAction func onSave(_ sender: Any) {
        NotificationManager.sharedInstance.setNotification(with: "GENERAL", time: datePicker.date, content: txtReminder.text!, isRepeat: true)
        _  = self.navigationController?.popViewController(animated: true)
    }
}
