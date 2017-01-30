//
//  SettingsViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var tblSettings: UITableView!
    var items = [SettingItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        items.append(SettingItem(title: "Reminder", detail: "", isAccessary: true))
        items.append(SettingItem(title: "Privacy", detail: "", isAccessary: true))
        items.append(SettingItem(title: "About", detail: "", isAccessary: true))
        items.append(SettingItem(title: "Contact Us", detail: "", isAccessary: true))
        items.append(SettingItem(title: "Rate Improvi", detail: "", isAccessary: true))
        
        self.tblSettings.reloadData()
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
        
    }
}
