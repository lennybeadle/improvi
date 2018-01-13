//
//  ChangePasswordViewController.swift
//  ImprovI
//
//  Created by Macmini on 2/4/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring
import SVProgressHUD

protocol ChangePasswordViewDelegate {
    func passwordChangedTo(value: String)
}

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var txtOldPassword: SpringTextField!
    @IBOutlet weak var txtNewPassword: SpringTextField!
    @IBOutlet weak var txtConfirmPassword: SpringTextField!
    
    var delegate: ChangePasswordViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtOldPassword.becomeFirstResponder()
    }
    
    @IBAction func onDone(_ sender: Any) {
        guard txtNewPassword.text != nil && txtNewPassword.text!.length > 0 else {
            showError(text: "Please type your New password again.")
            return
        }
        
        guard txtConfirmPassword.text != nil && txtConfirmPassword.text!.length > 0 else {
            showError(text: "Please type your Confirm password again.")
            return
        }
        
        guard txtOldPassword.text! == Manager.sharedInstance.currentUser.password else {
            showError(text: "Please type your old password again.")
            return
        }
        
        guard txtNewPassword.text! == txtConfirmPassword.text! else {
            showError(text: "Please confirm your new password again.")
            return
        }
        
        SVProgressHUD.show(withStatus: Constant.Keyword.loading)
        APIManager.changePassword(userId: Manager.sharedInstance.currentUser.id, password: txtNewPassword.text!, oldPassword: txtOldPassword.text!) { (result) in
            SVProgressHUD.dismiss()
            if (result) {
                self.txtOldPassword.text = nil
                self.txtNewPassword.text = nil
                self.txtConfirmPassword.text = nil
                
                self.alert(message: "Password successfully changed to " + self.txtNewPassword.text!)
                if self.delegate != nil {
                    self.delegate.passwordChangedTo(value: self.txtNewPassword.text!)
                }
                self.onBack(sender)
            }
            else {
                self.showError(text: "Please check the typed password again.")
            }
        }
    }
}
