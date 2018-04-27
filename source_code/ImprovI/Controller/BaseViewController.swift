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
    var featherCompletion: ((Int)->Void)? = nil
    
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
    
    @objc func onBack(_ sender: Any) {
        if let controller =  self.presentingViewController {
            controller.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func askPurchaseFeather(feathers: Int, completion: ((Int)->Void)?) {
        let controller = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "FeatherAskController") as! FeatherAskViewController
        controller.delegate = self
        controller.feathers = feathers
        controller.modalPresentationStyle = .overFullScreen
        controller.text = "Are you going to purchase \(feathers) feathers?"
        featherCompletion = completion
        self.present(controller, animated: false, completion: nil)
    }
    
    func askPurchaseFeather(completion: ((Int)->Void)?) {
        let controller = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "FeatherAskController") as! FeatherAskViewController
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        controller.text = "Not enough Feathers. Do you want to purchase more?"
        featherCompletion = completion
        self.present(controller, animated: false, completion: nil)
    }
    
    func askPurchaseFeather(text: String, completion: ((Int)->Void)?) {
        let controller = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "FeatherAskController") as! FeatherAskViewController
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        controller.text = text
        featherCompletion = completion
        self.present(controller, animated: false, completion: nil)
    }
    
    func askUnlockWithFeather(feathers: Int, completion: ((Int)->Void)?) {
        let controller = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "FeatherAskController") as! FeatherAskViewController
        controller.delegate = self
        controller.feathers = feathers
        controller.modalPresentationStyle = .overFullScreen
        controller.text = "Are you going to unlock this with \(feathers) feather(s)?"
        featherCompletion = completion
        self.present(controller, animated: false, completion: nil)
    }
}

extension BaseViewController: FeatherAskDelegate {
    func featherPurchaseRequired(feathers: Int) {
        if let completion = featherCompletion {
            completion(feathers)
        }
    }
}
