//
//  FeatherConvertViewController.swift
//  ImprovI
//
//  Created by Macmini on 4/9/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol FeatherConvertControllerDelegate {
    func exchangeCompleted()
}

class FeatherConvertViewController: BaseViewController {
    @IBOutlet weak var lblCurrentiXP: UILabel!
    @IBOutlet weak var txtFeathers: UITextField!
    @IBOutlet weak var alertView: UIView!
    var delegate: FeatherConvertControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 10
        self.alertView.layer.shadowColor = UIColor.gray.cgColor
        self.alertView.layer.shadowOpacity = 0.3
        self.alertView.layer.shadowRadius = 5
        self.alertView.layer.shadowOffset = CGSize(width: 1, height: 4)
        
        if let user = Manager.shared.currentUser {
            self.lblCurrentiXP.text = "You have \(user.totalIXP) iXP now."
        }
    }
    
    @IBAction func onConvert(_ sender: Any) {
        guard let text = self.txtFeathers.text, let feathers = Int(text), feathers > 0, let user = Manager.shared.currentUser else {
            self.alert(message: "Please input the number of feathers to purchase.")
            return
        }
        
        guard user.totalIXP >= feathers*250 else {
            self.alert(message: "Your ixp is not enough.")
            return
        }
        
        SVProgressHUD.show()
        APIManager.convertIXPToFeathers(userId: user.id, feathers: feathers) { (result) in
            SVProgressHUD.dismiss()
            if result {
                self.alert(message: "You've successfully exchanged iXP with feathers.", title: "Congratulations!", options: "Ok", completion: { (index) in
                    user.feathers = user.feathers + feathers
                    user.totalIXP = user.totalIXP - feathers * 250
                    if let delegate = self.delegate {
                        delegate.exchangeCompleted()
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            }
            else {
                self.alert(message: "Failed to exchange iXP to feathers. \n Try again later.", title: "Sorry", options: "Ok", completion: { (index) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
