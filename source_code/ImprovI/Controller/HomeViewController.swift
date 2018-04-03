//
//  HomeViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import Spring

class HomeViewController: BaseViewController {
    @IBOutlet weak var questionsBadge: SpringLabel!
    @IBOutlet weak var programmeBadge: SpringLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionsBadge.isHidden = true
        programmeBadge.isHidden = true
        
        if Manager.sharedInstance.allProgrammes.isEmpty {
            self.loadProgrammes()
        }
        self.loadQuestions()
    }
    
    func loadOnGoingJobs() {
        APIManager.numberOfOnGoingTasks(userId: Manager.sharedInstance.currentUser.id, completion: { (result) in
            if let result = result {
                self.updateProgrammeBadge(jobs: result.intValue)
            }
        })
    }
    
    func loadQuestions() {
        if Manager.sharedInstance.questions.count == 0 {
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
            APIManager.loadQuestion(userId: Manager.sharedInstance.currentUser.id, completion: { (questions) in
                SVProgressHUD.dismiss()
                if let newquiz = questions {
                    Manager.sharedInstance.questions.removeAll()
                    Manager.sharedInstance.questions.append(contentsOf: newquiz)
                    self.updateQuestionBadge()
                }
            })
        }
    }
    
    func updateProgrammeBadge(jobs: Int) {
        if jobs > 0 {
            programmeBadge.isHidden = false
            programmeBadge.text = "\(jobs)"
        }
        else {
            programmeBadge.isHidden = true
        }
    }
    
    func updateQuestionBadge() {
        if Manager.sharedInstance.questions.count > 0 {
            questionsBadge.isHidden = false
            questionsBadge.text = "\(Manager.sharedInstance.questions.count)"
        }
        else {
            questionsBadge.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateQuestionBadge()
        self.loadOnGoingJobs()
    }
    
    func loadProgrammes() {
        SVProgressHUD.show(withStatus: Constant.Keyword.loading)
        APIManager.getPrograms(userId: Manager.sharedInstance.currentUser.id) { (programmes) in
            SVProgressHUD.dismiss()
            if let programs = programmes {
                Manager.sharedInstance.allProgrammes = programs
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sid_programmes" {
            if Manager.sharedInstance.allProgrammes.count == 0 {
                self.alert(message: "Loading programmes... Please wait.")
                return false
            }
        }
        return true
    }
}
