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
    var pageController: UIPageViewController!
    var currentTaskViewController: DailyTaskViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwInfo.layer.cornerRadius = 10
        self.vwInfo.layer.masksToBounds = false
        
        self.vwInfo.layer.shadowColor = UIColor.gray.cgColor
        self.vwInfo.layer.shadowOpacity = 0.5
        self.vwInfo.layer.shadowRadius = 2
        self.vwInfo.layer.shadowOffset = CGSize(width: 0, height: 2)

        self.vwDailyTask.layer.shadowColor = UIColor.gray.cgColor
        self.vwDailyTask.layer.shadowOpacity = 0.3
        self.vwDailyTask.layer.shadowRadius = 5
        self.vwDailyTask.layer.shadowOffset = CGSize(width: 1, height: 4)
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
        }
        self.resetPageController()
    }
    
    func resetPageController() {
        self.pageController = UIPageViewController()
        self.pageController.dataSource = self
        self.pageController.delegate = self
        currentTaskViewController = self.dailyTaskViewController(at: 0)
        self.pageController.setViewControllers([currentTaskViewController], direction: .forward, animated: false, completion: nil)
        
        self.pageController.view.frame = self.vwDailyTask.bounds
        self.addChildViewController(self.pageController)
        self.vwDailyTask.addSubview(self.pageController.view)
        self.pageController.didMove(toParentViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    func taskStatusChanged(_ task: DailyTask, to: Status, completion: ((Bool)->Void)?) {
        if to == .completed {
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
            APIManager.completeTask(userId: Manager.sharedInstance.currentUser.id, programmeId: self.programme.id, taskId: task.id, completion: { (result) in
                SVProgressHUD.dismiss()

                if (result) {
                    task.status = to
                    self.selectedTask = task
                    Manager.sharedInstance.currentUser.totalIXP += task.boostPoint
                    self.showCongratulation()
                    
                    self.lblTimeRemaining.text = task.timeString
                    self.progressTime.progressValue = task.progress
                }
                if let completion = completion {
                    completion(result)
                }
            })
        }
        else if to == .ongoing {
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
            APIManager.startTask(userId: Manager.sharedInstance.currentUser.id, programmeId: self.programme.id, taskId: task.id, completion: { (result) in
                SVProgressHUD.dismiss()
                if (result) {
                    task.startedAt = Date()
                    task.status = to;
                    self.lblTimeRemaining.text = task.timeString
                    self.progressTime.progressValue = task.progress
                }
                
                if let completion = completion {
                    completion(result)
                }
            })
        }
    }
    
    func unlockTask(_ task: DailyTask, completion: ((Bool)->Void)?) {
        if task.status == .locked {
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
            APIManager.unlockTask(userId: Manager.sharedInstance.currentUser.id, programmeId: self.programme.id, taskId: task.id, completion: { (result) in
                SVProgressHUD.dismiss()
                task.status = .normal
                self.lblTimeRemaining.text = task.timeString
                self.progressTime.progressValue = task.progress
                
                if let completion = completion {
                    completion(true)
                }
            })
        }
        else {
            self.alert(message: "Daily Task is already unlocked.")
            if let completion = completion {
                completion(false)
            }
        }
    }
}

extension ProgrammeDetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func dailyTaskViewController(at index: Int) -> DailyTaskViewController {
        let controller = UIStoryboard(name: "Custom", bundle: nil).instantiateViewController(withIdentifier: "DailyTaskViewController") as! DailyTaskViewController
        controller.updateWithDailyTask(task: self.programme.tasks[index])
        controller.pageIndex = index
        controller.count = self.programme.tasks.count
        controller.delegate = self
        self.currentTaskViewController = controller
        
        self.lblTimeRemaining.text = self.programme.tasks[index].timeString
        self.progressTime.progressValue = self.programme.tasks[index].progress

        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! DailyTaskViewController).pageIndex
        if index == 0 {
            return nil
        }
        return self.dailyTaskViewController(at: index-1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! DailyTaskViewController).pageIndex
        if index >= self.programme.tasks.count-1{
            return nil
        }
        return self.dailyTaskViewController(at: index+1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.programme.tasks.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}


