//
//  SignUpViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func checkInputData() -> Bool {
        guard let username = txtUsername.text, username.characters.count > 0 else {
            self.showError(text: "Please check the username")
            return false
        }
        
        guard let password = txtPassword.text, password.characters.count > 0 else {
            self.showError(text: "Please check the password")
            return false
        }
        
        guard let confirm = txtConfirm.text, confirm.characters.count > 0 else {
            self.showError(text: "Please check the confirm")
            return false
        }
        
        guard password == confirm else {
            self.showError(text: "Passwords are not equivalant each other.")
            return false
        }
        
        return true
    }

    @IBAction func onSignUp(_ sender: Any) {
        if checkInputData() {
            self.performSegue(withIdentifier: "sid_home", sender: self)
        }
    }
}
