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
        
        if Manager.shared.allProgrammes.isEmpty {
            self.loadProgrammes()
        }
        self.loadQuestions()
    }
    
    func loadOnGoingJobs() {
        APIManager.numberOfOnGoingTasks(userId: Manager.shared.currentUser.id, completion: { (result) in
            if let result = result {
                self.updateProgrammeBadge(jobs: result.intValue)
            }
        })
    }
    
    func loadQuestions() {
        if Manager.shared.questions.count == 0 {
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
            APIManager.loadQuestion(userId: Manager.shared.currentUser.id, completion: { (questions) in
                SVProgressHUD.dismiss()
                if let newquiz = questions {
                    Manager.shared.questions.removeAll()
                    Manager.shared.questions.append(contentsOf: newquiz)
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
        if Manager.shared.questions.count > 0 {
            questionsBadge.isHidden = false
            questionsBadge.text = "\(Manager.shared.questions.count)"
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
        APIManager.getPrograms(userId: Manager.shared.currentUser.id) { (programmes) in
            SVProgressHUD.dismiss()
            if let programs = programmes {
                Manager.shared.allProgrammes = programs
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sid_programmes" {
            if Manager.shared.allProgrammes.count == 0 {
                self.alert(message: "Loading programmes... Please wait.")
                return false
            }
        }
        return true
    }
}
