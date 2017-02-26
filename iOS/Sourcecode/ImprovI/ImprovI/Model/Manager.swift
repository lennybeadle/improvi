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
    var currentUser: User! {
        didSet {
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
    }
    
    func approachProgrammes(programmes: [Programme]?) {
        self.allProgrammes.removeAll()
        if let programmes = programmes {
            for programme in programmes {
                self.allProgrammes.append(programme)
                if programme.status != .normal {
                    currentUser.addProgramme(programme)
                }
            }
        }
    }
    
    func sortProgrammes() {
        self.allProgrammes.sort { (programme1, programme2) -> Bool in
            return programme1.status.rawValue > programme2.status.rawValue
        }
    }
    
    func takeProgramme(programme: Programme) {
        NotificationManager.sharedInstance.setNotification(with: programme.id, name: programme.name, time: Date(), content: "Will you take new tasks in this programme?", isRepeat: true)
        programme.update()
    }
    
    func untakeProgramme(programme: Programme) {
        NotificationManager.sharedInstance.removeNotification(with: programme.id)
        programme.reset()
    }

    func initUISettings() {
        UINavigationBar.appearance().barTintColor = Constant.UI.foreColor
        UINavigationBar.appearance().tintColor = Constant.UI.backColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Constant.UI.backColor]
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
    
    func loadNewTasks(for programmeId: String) {
        SVProgressHUD.show()
        APIManager.getNewTask(userId: self.currentUser.id, programmeId: programmeId) { (newProgramme) in
            SVProgressHUD.dismiss()
            if let programme = self.currentUser.programme(with: programmeId), let newProgramme = newProgramme {
                programme.approachTasks(dailyTasks: newProgramme.tasks)
                programme.status = newProgramme.status
                programme.startTime = newProgramme.startTime
                DispatchQueue.main.async {
                    self.showProgrammeDetail(programme: programme)
                }
            }
        }
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
}
