//
//  Question.swift
//  ImprovI
//
//  Created by Macmini on 1/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class Answer: ImprovIObject {
    var content: String!
    var isCorrect: Bool!
    
    static func from(dict: [String: Any]) -> Answer {
        let answer = Answer()
        
        answer.id = "\(dict["id"]!)"
        answer.content = "\(dict["name"]!)"
        answer.isCorrect = false
        if let correctness = dict["correct"] as? String, correctness.boolValue == true {
            answer.isCorrect = true
        }
        return answer
    }
}

class Question: ImprovIObject {
    var question: String!
    var answers:[Answer]!
    var selectedAnswerIndex = -1
    var userAnswerId: String!
    
    override init(id: String) {
        super.init(id: id)
    }
    
    init() {
        super.init()
    }
    
    static func from(dict: [String: Any]) -> Question {
        let question = Question()
        
        question.id = "\(dict["id"]!)"
        question.question = "\(dict["name"]!)"
        if let userAnswer = dict["user_answer_id"], !(userAnswer is NSNull) {
            question.userAnswerId = "\(dict["user_answer_id"]!)"
        }
        question.collapsed = false

        if let answers = dict["answer"] as? [Any] {
            question.answers = answers.map{Answer.from(dict: ($0 as! [String: Any]))}
        }
        return question
    }
    
    func userAnswer() -> Answer? {
        if let userAnswerId = self.userAnswerId {
            for answer in self.answers {
                if answer.id == userAnswerId {
                    return answer
                }
            }
        }
        return nil
    }
    
    func userAnswerIndex() -> Int {
        guard let userAnswer = userAnswerId else {
            return -1
        }
        
        for i in 0..<self.answers.count {
            if answers[i].id == userAnswer {
                return i
            }
        }
        return -1
    }
}
