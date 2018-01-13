//
//  Manager.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class Manager {
    static let sharedInstance: Manager = Manager()
    
    var allProgrammes = [Programme]()
    var allTasks = [DailyTask]()
    
    var currentUser: User! {
        didSet {
            self.storeUserInfo()
        }
    }
    
    var analysisSubmitted: Bool {
        get {
            let standard = UserDefaults.standard
            return standard.bool(forKey: "analysisSubmitted")
        }
        set {
            let standard = UserDefaults.standard
            standard.set(newValue, forKey: "analysisSubmitted")
            standard.synchronize()
        }
    }
    
    var keepUserSignedIn: Bool {
        get {
            let standard = UserDefaults.standard
            return standard.bool(forKey: "KeepUserSignedIn")
        }
        set {
            let standard = UserDefaults.standard
            standard.set(newValue, forKey: "KeepUserSignedIn")
            standard.synchronize()
        }
    }
    
    var questions = [Question]()
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = Constant.UI.foreColor
        loadDailyTasks()
    }
    
    func storeUserInfo() {
        let standard = UserDefaults.standard
        if currentUser.userName != nil {
            standard.set(currentUser.userName, forKey: "username")
        }
        if currentUser.emailAddress != nil {
            standard.set(currentUser.emailAddress, forKey: "email")
        }
        if currentUser.password != nil {
            standard.set(currentUser.password, forKey: "password")
        }
        standard.synchronize()
    }
    
    func logOut() {
        let standard = UserDefaults.standard
        standard.set(nil, forKey: "username")
        standard.set(nil, forKey: "email")
        standard.set(nil, forKey: "password")
        standard.synchronize()
    }
    
    func loadDailyTasks() {
        let standard = UserDefaults.standard
        if let dailytasks = standard.array(forKey: "dailytasks") {
            self.allTasks = dailytasks.map {DailyTask.from(dict: $0 as! [String: Any])}
        }
        else {
            APIManager.getDailyTasks { (tasks) in
                if let tasks = tasks {
                    self.allTasks = tasks
                }
            }
        }
    }
    
    func sortProgrammes() {
        self.allProgrammes.sort { (programme1, programme2) -> Bool in
            return programme1.status.rawValue > programme2.status.rawValue
        }
    }

    func initUISettings() {
        UINavigationBar.appearance().barTintColor = Constant.UI.foreColor
        UINavigationBar.appearance().tintColor = Constant.UI.backColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: Constant.UI.backColor]
        UIApplication.shared.statusBarStyle = .lightContent
    }

    func loadQuizState() {
        let standard = UserDefaults.standard
        if let state = standard.dictionary(forKey: "quiz_state") {
            for question in self.questions {
                if let selectedIndex = state[question.id!] as? Int {
                    question.selectedAnswerIndex = selectedIndex
                }
            }
        }
    }
    
    func saveQuizState() {
        let standard = UserDefaults.standard
        var state = standard.dictionary(forKey: "quiz_state") ?? [String: Int]()
        for question in self.questions {
            if question.selectedAnswerIndex != -1 {
                state[question.id!] = question.selectedAnswerIndex
            }
        }
        standard.set(state, forKey: "quiz_state")
        standard.synchronize()
    }
    
    func quizSelected() -> Bool {
        for question in self.questions {
            if question.selectedAnswerIndex == -1 {
                return false
            }
        }
        return true
    }
    
    func showProgrammeDetail(programme: Programme) {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            if let storyboard = navigationController.storyboard {
                if let detailController = storyboard.instantiateViewController(withIdentifier: "sid_programme_detail") as? ProgrammeDetailViewController {
                    detailController.programme = programme
                    navigationController.pushViewController(detailController, animated: true)
                }
            }
        }
    }
    
    func showProgrammeList() {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            if let storyboard = navigationController.storyboard {
                if let listController = storyboard.instantiateViewController(withIdentifier: "sid_programme_list") as? ProgrammeViewController {
                    navigationController.pushViewController(listController, animated: true)
                }
            }
        }
    }
    
    func purchaseFeathers(product: Products,  completion: ((Bool)->Void)?) {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            SVProgressHUD.show()
            PurchaseManager.shared.loadProducts { (result) in
                SVProgressHUD.dismiss()
                if result {
                    SVProgressHUD.show()
                    PurchaseManager.shared.purchaseProduct(product: product.identifier) { (result) in
                        SVProgressHUD.dismiss()
                        if result {
                            let alert = UIAlertController(title: "Success", message: "Your have purchased \(product.feathers) feathers.", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alert.addAction(action)
                            navigationController.present(alert, animated: true, completion: nil)
                            
                            if let currentUser = Manager.sharedInstance.currentUser {
                                currentUser.feathers = currentUser.feathers + product.feathers
                            }
                            
                            SVProgressHUD.show()
                            APIManager.featherPurchased(userId: Manager.sharedInstance.currentUser.id, feathers: product.feathers, completion: { (result) in
                                SVProgressHUD.dismiss()
                                if result {
                                    if let completion = completion {
                                        completion(true)
                                    }
                                }
                                else {
                                    if let completion = completion {
                                        completion(false)
                                    }
                                }
                            })
                        }
                        else {
                            let alert = UIAlertController(title: "Failure", message: "Please try again later", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alert.addAction(action)
                            navigationController.present(alert, animated: true, completion: nil)
                            if let completion = completion {
                                completion(false)
                            }
                        }
                    }
                }
                else {
                    let alert = UIAlertController(title: "Failure", message: "Error loading products, please try again later.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    navigationController.present(alert, animated: true, completion: nil)
                    if let completion = completion {
                        completion(false)
                    }
                }
            }
        }
    }
}
