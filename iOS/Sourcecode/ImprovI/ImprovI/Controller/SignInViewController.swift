//
//  SignInViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import LTMorphingLabel
import SVProgressHUD
import IQKeyboardManagerSwift

class SignInViewController: BaseViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblTitle: LTMorphingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "IMPROVI"
        // Do any additional setup after loading the view.
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
        return true
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        self.view.resignFirstResponder()
        if self.checkInputData() {
            SVProgressHUD.show(withStatus: "A sec, please")
            if self.txtUsername.text!.isValidEmail() {
                APIManager.login(with: nil, email: txtUsername.text, password: txtPassword.text!, completion: { (user, programmes) in
                    SVProgressHUD.dismiss()
                    if user == nil {
                        return
                    }
                    Manager.sharedInstance.currentUser = user
                    Manager.sharedInstance.approachProgrammes(programmes: programmes)
                    IQKeyboardManager.sharedManager().resignFirstResponder()
                    self.performSegue(withIdentifier: "sid_home", sender: self)
                })
            }
            else {
                APIManager.login(with: txtUsername.text, email: nil, password: txtPassword.text!, completion: { (user, programmes) in
                    SVProgressHUD.dismiss()
                    if user == nil {
                        return
                    }
                    Manager.sharedInstance.currentUser = user
                    Manager.sharedInstance.approachProgrammes(programmes: programmes)
                    IQKeyboardManager.sharedManager().resignFirstResponder()
                    self.performSegue(withIdentifier: "sid_home", sender: self)
                })
            }
        }
    }
}
