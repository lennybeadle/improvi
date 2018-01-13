//
//  ProgrammeDetailViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/28/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProgrammeDetailViewController: BaseViewController {
    var programme: Programme!
    
    var swipeView: DMSwipeCardsView<DailyTask>!
    @IBOutlet weak var vwInfo: UIView!
    
    @IBOutlet weak var vwDailyTask: UIView!
    @IBOutlet weak var progressBar: LinearProgressView!
    @IBOutlet weak var progressTime: LinearProgressView!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var lblTimeRemaining: UILabel!

    weak var selectedTask: DailyTask! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwInfo.layer.cornerRadius = 10
        self.vwInfo.layer.masksToBounds = false
        
        self.vwInfo.layer.shadowColor = UIColor.gray.cgColor
        self.vwInfo.layer.shadowOpacity = 0.5
        self.vwInfo.layer.shadowRadius = 2
        self.vwInfo.layer.shadowOffset = CGSize(width: 0, height: 2)

        self.loadProgramDetail()
    }
    
    func loadProgramDetail() {
        SVProgressHUD.show()
        APIManager.getProgramDetail(userId: Manager.sharedInstance.currentUser.id, programmeId: programme.id) { (dict) in
            SVProgressHUD.dismiss()
            if let dict = dict, dict.count > 0 {
                let usertasks = dict["user_tasks"] as! [Any]
                self.programme.applyTaskStatus(with: usertasks)
                self.resetWithProgramme()
            }
        }
    }
    
    func resetWithProgramme() {
        if self.programme != nil {
            self.title = programme.name
            progressBar.progressValue = CGFloat(self.programme.progress)
            self.lblProgress.text = "\(programme.type): \(Int(self.programme.progress))%"
            
            self.lblTimeRemaining.text = self.programme.timeString
            self.progressTime.progressValue = self.programme.timeProgress
        }
    }
    
    func initSwipeView() {
        let viewGenerator: (DailyTask, CGRect) -> (UIView) = { (element: DailyTask, frame: CGRect) -> (UIView) in
            let container = UIView(frame: CGRect(x: 20, y: 10, width: frame.width - 40, height: frame.height - 20))
            
            if let taskView = Bundle.main.loadNibNamed("DailyTaskView", owner: nil, options: nil)?.first as? DailyTaskView {
                taskView.updateWithDailyTask(task: element)
                taskView.delegate = self
                
                taskView.updateIndex(index: self.programme.index(of: element), count: self.programme.tasks.count)
                
                container.addSubview(taskView)
                
                taskView.frame = container.bounds
                taskView.backgroundColor = Constant.UI.backColor
                taskView.clipsToBounds = true
                taskView.layer.cornerRadius = 16

                let views = [
                    "taskView" : taskView
                ]
                
                container.addConstraints(NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|-[taskView]-|",
                    options: [],
                    metrics: nil,
                    views: views
                ))
                
                container.addConstraints(NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|-[taskView]-|",
                    options: [],
                    metrics: nil,
                    views: views
                ))
            }
            
            container.layer.shadowRadius = 4
            container.layer.shadowOpacity = 1.0
            container.layer.shadowColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            container.layer.shadowOffset = CGSize(width: 0, height: 0)
            container.layer.shouldRasterize = true
            container.layer.rasterizationScale = UIScreen.main.scale
            
            return container
        }
        
        let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
            let effectView = UIVisualEffectView()
            effectView.frame = CGRect(x: 20, y: 10, width: frame.width - 40, height: frame.height - 20)
            effectView.layer.cornerRadius = 16
            effectView.backgroundColor = Constant.UI.foreColorLight.withAlphaComponent(0.5)
            effectView.layer.masksToBounds = true
            effectView.effect = UIBlurEffect(style: UIBlurEffectStyle.regular)
            return effectView
        }
        
        let frame = CGRect(x: 0, y: 0, width: self.vwDailyTask.frame.width, height: self.vwDailyTask.frame.height)
        swipeView = DMSwipeCardsView<DailyTask>(frame: frame,
                                                viewGenerator: viewGenerator,
                                                overlayGenerator: overlayGenerator)
        swipeView.delegate = self
        self.vwDailyTask.addSubview(swipeView)
//        swipeView.bufferSize = self.programme.tasks.count
        self.swipeView.addCards(self.programme.tasks, onTop: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initSwipeView()
    }
    
    func showCongratulation() {
        self.performSegue(withIdentifier: "sid_congratulation", sender: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sid_congratulation" {
            if self.selectedTask == nil {
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sid_congratulation" {
            let controller = segue.destination as! CongratulationViewController
            controller.task = self.selectedTask
        }
    }
}

extension ProgrammeDetailViewController: DailyTaskViewDelegate {
    func taskStatusChanged(_ task: DailyTask) {
        if task.status == .completed {
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
            APIManager.completeTask(userId: Manager.sharedInstance.currentUser.id, programmeId: self.programme.id, taskId: task.id, completion: { (result) in
                SVProgressHUD.dismiss()
                self.selectedTask = task
                Manager.sharedInstance.currentUser.totalIXP += task.boostPoint
                self.showCongratulation()
                self.resetWithProgramme()
            })
        }
    }
}

extension ProgrammeDetailViewController: DMSwipeCardsViewDelegate {
    func swipedLeft(_ object: Any) {
        print("Swiped left: \(object)")
    }
    
    func swipedRight(_ object: Any) {
        print("Swiped right: \(object)")
    }
    
    func cardTapped(_ object: Any) {
        print("Tapped on: \(object)")
    }
    
    func reachedEndOfStack() {
        self.callAfter(second: 0.5, inBackground: false) {
            self.swipeView.addCards(self.programme.tasks, onTop: false)
        }
        print("Reached end of stack")
    }
}

