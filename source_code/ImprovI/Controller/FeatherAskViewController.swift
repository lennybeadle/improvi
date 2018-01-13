//
//  FeatherAskViewController.swift
//  ImprovI
//
//  Created by Macmini on 12/28/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
protocol FeatherAskDelegate {
    func featherPurchaseRequired(feathers: Int)
}

class FeatherAskViewController: UIViewController {
    var feathers: Int = 0
    @IBOutlet weak var lblQuestion: UILabel!
    var delegate: FeatherAskDelegate!
    var text: String!
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 10
        self.alertView.layer.shadowColor = UIColor.gray.cgColor
        self.alertView.layer.shadowOpacity = 0.3
        self.alertView.layer.shadowRadius = 5
        self.alertView.layer.shadowOffset = CGSize(width: 1, height: 4)

        lblQuestion.text = text
    }
    
    @IBAction func onYes(_ sender: Any) {
        self.dismiss(animated: true) {
            if self.delegate != nil {
                self.delegate.featherPurchaseRequired(feathers: self.feathers)
            }
        }
    }
    
    @IBAction func onNo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
