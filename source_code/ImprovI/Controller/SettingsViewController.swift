//
//  SettingsViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import iRate

class SettingsViewController: BaseViewController {

    @IBOutlet weak var tblSettings: UITableView!
    var items = [SettingItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if isAnimated {
           self.reload()
//        }
    }
    
    func reload() {
        NotificationManager.shared.getNotificationInfo(with: "GENERAL") { (date, title, body) in
            self.items.removeAll()
            var reminderContent = ""
            if let date = date {
                reminderContent = "\(date.hour):\(date.minute)"
            }
            
            self.items.append(SettingItem(title: "Reminder", detail: reminderContent, isAccessary: true))
            self.items.append(SettingItem(title: "Privacy Policy", detail: "", isAccessary: true))
            self.items.append(SettingItem(title: "Contact Us", detail: "", isAccessary: true))
            self.items.append(SettingItem(title: "Rate improv-i", detail: "", isAccessary: true))
            self.items.append(SettingItem(title: "Sign Out", detail: "", isAccessary: false))
            
            DispatchQueue.main.async {
                self.tblSettings.reloadData()
            }
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        if let customCell = cell as? SettingsTableViewCell {
            customCell.resetWithTitle(title: items[indexPath.row].title, detail: items[indexPath.row].detail)
            customCell.isAccessory = items[indexPath.row].isAccessary
            
            if isAnimated == false {
                customCell.vwInnerView.delay = 0.05*CGFloat(indexPath.row)
                customCell.vwInnerView.animate()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "sid_reminder", sender: self)
        }
        else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "sid_privacypolicy", sender: self)
        }
        else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "sid_contactus", sender: self)
        }
        else if indexPath.row == 3 {
            iRate.sharedInstance().promptForRating()
        }
        else if indexPath.row == 4 {
            Manager.shared.logOut()
            let _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
