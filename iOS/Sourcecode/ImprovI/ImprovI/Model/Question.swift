//
//  Question.swift
//  ImprovI
//
//  Created by Macmini on 1/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class Question: ImprovIObject {
    var question: String!
    var answers:[String]!
    var selectedAnswerIndex: Int = -1
    
    override init(id: String) {
        super.init(id: id)
    }
    
    init(question: String, answers: [String]? = nil) {
        super.init()
        self.question = question
        self.answers = answers
        self.collapsed = false
    }
}
