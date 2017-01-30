//
//  ProfileViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

class SettingItem {
    var title: String!
    var detail: String!
    var isAccessary: Bool!
    
    init(title: String, detail: String, isAccessary: Bool) {
        self.title = title
        self.detail = detail
        self.isAccessary = isAccessary
    }
}

class ProfileViewController: BaseViewController {
    @IBOutlet weak var tblContents: UITableView!
    @IBOutlet weak var imgUser: SpringImageView!
    @IBOutlet weak var lblUsername: SpringLabel!

    var items = [SettingItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        imgUser.layer.cornerRadius = imgUser.frame.size.width/2
        imgUser.layer.borderColor = Constant.UI.foreColor.cgColor
        imgUser.layer.borderWidth = 3
        imgUser.layer.masksToBounds = true
        
        lblUsername.text = Manager.sharedInstance.currentUser.fullName
        items.append(SettingItem(title: "Full name", detail: Manager.sharedInstance.currentUser.fullName, isAccessary: true))
        items.append(SettingItem(title: "Email Address", detail: Manager.sharedInstance.currentUser.emailAddress, isAccessary: true))
        items.append(SettingItem(title: "Change Password", detail: "", isAccessary: true))
        items.append(SettingItem(title: "Date joined", detail: Manager.sharedInstance.currentUser.dateJoined.dateString, isAccessary: false))
        items.append(SettingItem(title: "Total IXP", detail: "\(Manager.sharedInstance.currentUser.totalIXP)", isAccessary: false))
        items.append(SettingItem(title: "Sign Out", detail: "", isAccessary: false))

        self.tblContents.reloadData()
        // Do any additional setup after loading the view.
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
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
        if indexPath.row == 5 {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
