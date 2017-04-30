//
//  BaseViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @IBInspectable var showNavigationBar: Bool = false
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var titleView: UIView!
    var isAnimated: Bool = false

    override var title: String? {
        didSet {
            if self.titleView.subviews.count > 1{
                let lblTitle = self.titleView.subviews[0]
                if lblTitle is UILabel {
                    (lblTitle as! UILabel).text = title
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController {
            if self.showNavigationBar {
                navigationController.isNavigationBarHidden = false
            }
            else {
                navigationController.isNavigationBarHidden = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAnimated = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.btnBack != nil {
            self.btnBack.addTarget(self, action: #selector(BaseViewController.onBack(_:)), for: .touchUpInside)
        }
        
        if self.titleView != nil {
            self.titleView.layer.shadowColor = UIColor.gray.cgColor
            self.titleView.layer.shadowOpacity = 0.8
            self.titleView.layer.shadowRadius = 10
            self.view.bringSubview(toFront: self.titleView)
        }
        
        if self.view.backgroundColor == UIColor.white {
            self.view.backgroundColor = Constant.UI.backColor
        }
    }
    
    func onBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
