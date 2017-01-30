//
//  Manager.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class Manager {
    static let sharedInstance: Manager = Manager()
    
    var allProgrammes = [Programme]()
    var currentUser: User!
    
    var questions = [Question]()
    
    init() {
        currentUser = User()
        currentUser.fullName = "Lenny Beadle"
        currentUser.userName = "lenny_beadle"
        currentUser.emailAddress = "lennybeadle@gmail.com"
        currentUser.totalIXP = 120
        currentUser.dateJoined = Date()
        
        self.loadProgramme()
        self.loadQuestions()
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = Constant.UI.foreColor
    }
    
    func loadQuestions() {
        self.questions.append(Question(question: "WHAT DO YOU DO", answers: ["I’m a student.", "I work in a bank.", "I’m unemployed at the moment.", "I run my own business."]))
        self.questions.append(Question(question: "ARE YOU MARRIED?", answers: ["Yes", "I’m divorced.", "I’m engaged.", "No, but I’m in a relationship.", "Nope, I’m single."]))
        self.questions.append(Question(question: "WHY ARE YOU STUDYING ENGLISH?", answers: ["For work.", "So I can communicate when I travel.", "I love learning new languages.", "I’m thinking of studying in England.", "Because I’d like to immigrate to the U.S."]))
        self.questions.append(Question(question: "WHERE/HOW DID YOU LEARN ENGLISH?", answers: ["I took classes for three years.", "I did an intensive course.", "I’ve been studying on my own."]))
        self.questions.append(Question(question: "WHAT DO YOU DO IN YOUR FREE TIME?", answers: ["I don’t have any free time!", "I usually hang out with friends.", "I go running a lot.", "I do volunteer work.", "I like reading and relaxing at home."]))
    }
    
    func loadProgramme() {
        //        currentUser.addProgramme(Programme(id: "1", name: "Improvi Fitness"))
        //        currentUser.addProgramme(Programme(id: "2", name: "Improvi Health"))
        //        currentUser.addProgramme(Programme(id: "3", name: "Improvi Body"))
        //        currentUser.addProgramme(Programme(id: "4", name: "Improvi Leg"))
        //        currentUser.addProgramme(Programme(id: "0", name: "Improvi Test"))
        self.allProgrammes.append(Programme(id: "1", name: "Improvi Fitness"))
        self.allProgrammes.append(Programme(id: "2", name: "Improvi Health"))
        self.allProgrammes.append(Programme(id: "3", name: "Improvi Body"))
        self.allProgrammes.append(Programme(id: "4", name: "Improvi Leg"))
        self.allProgrammes.append(Programme(id: "5", name: "Improvi Arms"))
    }
    
    func initUISettings() {
        UINavigationBar.appearance().barTintColor = Constant.UI.foreColor
        UINavigationBar.appearance().tintColor = Constant.UI.backColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Constant.UI.backColor]
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
