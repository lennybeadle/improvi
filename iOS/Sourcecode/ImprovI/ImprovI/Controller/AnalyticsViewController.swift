//
//  AnalyticsViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class AnalyticsViewController: BaseViewController {
    @IBOutlet weak var tblQuestions: UITableView!
    var questions: [Question]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questions = Manager.sharedInstance.questions
        self.loadQuestions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadQuestions() {
        if questions.count == 0 {
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
            APIManager.loadQuestion(completion: { (questions) in
                SVProgressHUD.dismiss()
                if let newquiz = questions {
                    Manager.sharedInstance.questions.removeAll()
                    Manager.sharedInstance.questions.append(contentsOf: newquiz)
                    Manager.sharedInstance.loadQuizState()
                    self.questions = Manager.sharedInstance.questions
                    self.isAnimated = false
                    self.tblQuestions.reloadData()
                    self.callAfter(second: 2, inBackground: true, execute: {
                        self.isAnimated = true
                    })
                }
            })
        }
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        guard Manager.sharedInstance.quizSelected() else {
            self.alert(message: "You have not selected all answers yet. Please check again", title: "")
            return
        }
        
        if Manager.sharedInstance.analysisSubmitted == false {
            SVProgressHUD.show()
            APIManager.featherPurchased(userId: Manager.sharedInstance.currentUser.id, feathers: 10, completion: { (result) in
                SVProgressHUD.dismiss()
                if result {
                    Manager.sharedInstance.analysisSubmitted = true
                    Manager.sharedInstance.currentUser.feathers = Manager.sharedInstance.currentUser.feathers + 10
                    self.alert(message: "You have gained 10 Feathers by submitting your answer.", title: "Congratulations", options: "Ok", completion: { (buttonIndex) in
                        self.performSegue(withIdentifier: "sid_feathers", sender: self)
                    })
                }
                else {
                    self.alert(message: "Network is busy now, try again, please.", title: "Sorry...")
                }
            })
        }
        else {
            self.alert(message: "You have already submitted your answer.", title: "Hmm...")
        }
    }
}

extension AnalyticsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = questions[section].question
        header.arrowLabel.text = ">"
        header.setCollapsed(collapsed: questions[section].collapsed)
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if questions[indexPath.section].collapsed {
            return 0
        }
        else {
            return AnswerTableViewCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions[section].answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        if let customCell = cell as? AnswerTableViewCell {
            let question = questions[indexPath.section]
            customCell.resetWithAnswer(answer: question.answers[indexPath.row], selected: question.selectedAnswerIndex == indexPath.row)
            
            if self.isAnimated == false{
                customCell.vwInnerView.delay = 0.05*CGFloat(indexPath.row)
                customCell.vwInnerView.animate()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = questions[indexPath.section]
        question.selectedAnswerIndex = indexPath.row
        Manager.sharedInstance.saveQuizState()
        
        tblQuestions.beginUpdates()
        for i in 0 ..< questions[indexPath.section].answers.count {
            tblQuestions.reloadRows(at: [IndexPath(row: i, section: indexPath.section)], with: .automatic)
        }
        tblQuestions.endUpdates()
    }
}

extension AnalyticsViewController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = questions[section].collapsed
        
        // Toggle collapse
        questions[section].collapsed = !collapsed
        header.setCollapsed(collapsed: !collapsed)
        
        // Adjust the height of the rows inside the section
        tblQuestions.beginUpdates()
        for i in 0 ..< questions[section].answers.count {
            tblQuestions.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tblQuestions.endUpdates()
    }
}
