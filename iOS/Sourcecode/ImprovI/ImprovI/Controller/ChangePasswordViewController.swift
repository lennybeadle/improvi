//
//  ChangePasswordViewController.swift
//  ImprovI
//
//  Created by Macmini on 2/4/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

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
        guard txtOldPassword.text! == Manager.sharedInstance.currentUser.password else {
            showError(text: "Please type your old password again.")
            return
        }
        
        guard txtNewPassword.text! == txtConfirmPassword.text! else {
            showError(text: "Please confirm your new password again.")
            return
        }
        
        if delegate != nil {
            self.delegate.passwordChangedTo(value: txtNewPassword.text!)
        }
        self.onBack(sender)
    }
}
