//
//  TextInputViewController.swift
//  ImprovI
//
//  Created by Macmini on 2/4/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

protocol TextInputViewControllerDelegate {
    func textChangedTo(value: String, from: String, forTextType: String)
}

class TextInputViewController: BaseViewController {
    @IBOutlet weak var txtValue: SpringTextField!
    var delegate: TextInputViewControllerDelegate!

    var placeHolder: String = "Input the text here"
    var defaultValue: String = ""
    var textType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtValue.placeholder = self.placeHolder
        txtValue.text = defaultValue
        self.title = self.textType
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtValue.becomeFirstResponder()
    }

    @IBAction func onDone(_ sender: Any) {
        if self.delegate != nil {
            self.delegate.textChangedTo(value: txtValue.text!, from: self.defaultValue, forTextType: self.textType)
        }
        self.onBack(sender)
    }
}
