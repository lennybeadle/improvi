//
//  AppDelegate.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import iRate
import IQKeyboardManagerSwift
import UserNotifications
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initSettings()
        initUI()
        PurchaseManager.shared.completeIAPTransactions()
        return true
    }
    
    func initSettings() {
        UIManager.shared.appDelegate = self
        UIManager.shared.initSettings()
        iRate.sharedInstance().appStoreID = 10289384
        iRate.sharedInstance().onlyPromptIfLatestVersion = true
        
        IQKeyboardManager.sharedManager().enable = true
        
        LJNotificationScheduler.requestAuthrization()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = NotificationManager.shared
        } else {
            // Fallback on earlier versions
        }
    }

    func initUI() {
        if Manager.sharedInstance.keepUserSignedIn {
            let standard = UserDefaults.standard
            let username = standard.string(forKey: "username")
            let email = standard.string(forKey: "email")
            let password = standard.string(forKey: "password") ?? ""
            if username != nil || email != nil {
                SVProgressHUD.show(withStatus: Constant.Keyword.loading)
                APIManager.login(with: username, email: email, password: password, completion: { (user) in
                    SVProgressHUD.dismiss()
                    if user != nil {
                        Manager.sharedInstance.currentUser = user
//                        Manager.sharedInstance.approachProgrammes(programmes: programmes)
                        UIManager.shared.showMain()
                    }
                    else {
                        UIManager.shared.showLogin()
                    }
                })
                return
            }
        }
        UIManager.shared.showLogin()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

