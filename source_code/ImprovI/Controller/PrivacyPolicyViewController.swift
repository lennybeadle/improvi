//
//  PrivacyPolicyViewController.swift
//  ImprovI
//
//  Created by Macmini on 2/5/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class PrivacyPolicyViewController: BaseViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SVProgressHUD.show()
        loadHtml()
    }
    
    func loadHtml() {
        if let path = Bundle.main.path(forResource: "privacypolicy", ofType: "html") {
            let url = URL(fileURLWithPath: path)
            do {
                let htmlString = try String(contentsOf: url)
                self.webView.loadHTMLString(htmlString, baseURL: nil)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension PrivacyPolicyViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
