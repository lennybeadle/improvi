//
//  AnalyticsViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class AnalyticsViewController: BaseViewController {
    @IBOutlet weak var tblQuestions: UITableView!
    var questions: [Question]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questions = Manager.sharedInstance.questions
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
            
            if isAnimated == false {
                customCell.vwInnerView.delay = 0.05*CGFloat(indexPath.row)
                customCell.vwInnerView.animate()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = questions[indexPath.section]
        question.selectedAnswerIndex = indexPath.row
        
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
