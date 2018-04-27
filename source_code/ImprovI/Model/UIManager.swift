//
//  UIFlowManager.swift
//  DocHub
//
//  Created by Macmini on 2/22/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class UIManager{
    static let shared = UIManager()
    var appDelegate: AppDelegate!
    
    func initSettings() {
        UINavigationBar.appearance().barTintColor = Constant.UI.foreColor
        UINavigationBar.appearance().tintColor = Constant.UI.backColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: Constant.UI.backColor]
        UIApplication.shared.statusBarStyle = .lightContent
        
        SVProgressHUD.setDefaultMaskType(.clear)
    }
}

extension UIManager {
    enum ViewController {
        case Login, Main
        
        var viewController: UIViewController
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            switch self {
            case .Login:
                return storyboard.instantiateViewController(withIdentifier: "sid_login")
            case .Main:
                return storyboard.instantiateViewController(withIdentifier: "sid_main")
            }
        }
    }
    
    func showLogin(animated: Bool = false)
    {
        _ = (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
    }
    
    func showMain(animated: Bool = false)
    {
        let viewController = ViewController.Main.viewController
        viewController.navigationController?.isNavigationBarHidden = true
        (appDelegate.window?.rootViewController as? UINavigationController)?.pushViewController(viewController, animated: animated)
    }
    
    func isiPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
