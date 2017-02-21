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
        if let image = Manager.sharedInstance.currentUser.image {
            self.imgUser.image = image
        }
        
        self.reload()
    }
    
    func reload() {
        self.items.removeAll()
        items.append(SettingItem(title: "Full name", detail: Manager.sharedInstance.currentUser.fullName, isAccessary: true))
        items.append(SettingItem(title: "Email Address", detail: Manager.sharedInstance.currentUser.emailAddress, isAccessary: true))
        items.append(SettingItem(title: "Change Password", detail: "", isAccessary: true))
        items.append(SettingItem(title: "Date joined", detail: Manager.sharedInstance.currentUser.dateJoined.dateString, isAccessary: false))
        var ixp = Manager.sharedInstance.currentUser.totalIXP
        if ixp == -1 {
            ixp = 0
        }
        items.append(SettingItem(title: "Total IXP", detail: "\(ixp)", isAccessary: false))
        items.append(SettingItem(title: "Sign Out", detail: "", isAccessary: false))
        self.tblContents.reloadData()
    }
    
    @IBAction func onProfilePhoto(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Take a photo from", message: "", preferredStyle: .actionSheet)
        let actionTakePhoto = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.takePhoto(sourceType: .photoLibrary)
        }
        
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.takePhoto(sourceType: .camera)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(actionTakePhoto)
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionCancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func takePhoto(sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.imgUser.image = selectedImage.resizeImage(newWidth: 200)
        Manager.sharedInstance.currentUser.image = self.imgUser.image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: ChangePasswordViewDelegate {
    func passwordChangedTo(value: String) {
        Manager.sharedInstance.currentUser.password = value
        self.reload()
    }
}

extension ProfileViewController: TextInputViewControllerDelegate {
    internal func textChangedTo(value: String, from: String, forTextType: String) {
        if forTextType == "Full name" {
            Manager.sharedInstance.currentUser.fullName = value
        }
        else if forTextType == "Email" {
            Manager.sharedInstance.currentUser.emailAddress = value
        }
        self.reload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sid_fullname" {
            let textInputController = segue.destination as! TextInputViewController
            textInputController.delegate = self
            textInputController.defaultValue = Manager.sharedInstance.currentUser.fullName
            textInputController.placeHolder = "Type your new name here, please"
            textInputController.textType = "Full name"
        }
        else if segue.identifier == "sid_email" {
            let textInputController = segue.destination as! TextInputViewController
            textInputController.delegate = self
            textInputController.defaultValue = Manager.sharedInstance.currentUser.emailAddress
            textInputController.placeHolder = "Type your email address here, please"
            textInputController.textType = "Email"
        }
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
        if indexPath.row == 0 { // Full name change
            self.performSegue(withIdentifier: "sid_fullname", sender: self)
        }
        else if indexPath.row == 1 { // Email Change
            self.performSegue(withIdentifier: "sid_email", sender: self)
        }
        else if indexPath.row == 2 { // Password Change
            self.performSegue(withIdentifier: "sid_changepassword", sender: self)
        }
        else if indexPath.row == 5 {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
