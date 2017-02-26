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
    @IBOutlet weak var btnSelected: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btnSelected.isSelected = Manager.sharedInstance.keepUserSignedIn
        print("Selected - \(btnSelected.isSelected)")
        if Manager.sharedInstance.keepUserSignedIn {
            let standard = UserDefaults.standard
            let username = standard.string(forKey: "username")
            let email = standard.string(forKey: "email")
            let password = standard.string(forKey: "password") ?? ""
            let un = username ?? email ?? ""
            self.txtUsername.text = un
            self.txtPassword.text = password
        }
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
    
    @IBAction func onKeepMeSignedIn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        Manager.sharedInstance.keepUserSignedIn = sender.isSelected
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        self.view.resignFirstResponder()
        if self.checkInputData() {
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
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
