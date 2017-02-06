//
//  ContactUSViewController.swift
//  ImprovI
//
//  Created by Macmini on 2/5/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MessageUI

class ContactUSViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onEmail(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([sender.title(for: .normal)!])
            mail.setMessageBody("<p>Hi, ImprovI</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            showError(text: "Email is not enabled on your device.")
        }
    }
    
    @IBAction func onPhoneCall(_ sender: UIButton) {
        guard let number = URL(string: "telprompt://" + sender.title(for: .normal)!) else {
            showError(text: "Phone Call is not enabled on your device.")
            return
        }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
}

extension ContactUSViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
