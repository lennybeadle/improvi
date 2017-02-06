//
//  ProgrammeDetailViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/28/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import DMSwipeCards

class ProgrammeDetailViewController: BaseViewController {
    var programme: Programme!
    
    var swipeView: DMSwipeCardsView<DailyTask>!
    @IBOutlet weak var vwInfo: UIView!
    
    @IBOutlet weak var vwDailyTask: UIView!
    @IBOutlet weak var progressBar: LinearProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwInfo.layer.cornerRadius = 10
        self.vwInfo.layer.masksToBounds = false
        
        self.vwInfo.layer.shadowColor = UIColor.gray.cgColor
        self.vwInfo.layer.shadowOpacity = 0.5
        self.vwInfo.layer.shadowRadius = 2
        self.vwInfo.layer.shadowOffset = CGSize(width: 0, height: 2)

        if self.programme != nil {
            self.title = programme.name
            progressBar.progressValue = CGFloat(self.programme.progress)
        }
    }
    
    func initSwipeView() {
        let viewGenerator: (DailyTask, CGRect) -> (UIView) = { (element: DailyTask, frame: CGRect) -> (UIView) in
            let container = UIView(frame: CGRect(x: 20, y: 10, width: frame.width - 40, height: frame.height - 20))
            
            if let taskView = Bundle.main.loadNibNamed("DailyTaskView", owner: nil, options: nil)?.first as? DailyTaskView {
                taskView.updateWithDailyTask(task: element)
                taskView.updateDate(date: self.programme.startTime)
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
        
        self.swipeView.addCards(self.programme.tasks, onTop: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initSwipeView()
    }
}

extension ProgrammeDetailViewController: DMSwipeCardsViewDelegate {
    func swipedLeft(_ object: Any) {
        self.swipeView.addCards([object as! DailyTask], onTop: false)
        print("Swiped left: \(object)")
    }
    
    func swipedRight(_ object: Any) {
        print("Swiped right: \(object)")
        self.swipeView.addCards([object as! DailyTask], onTop: false)
    }
    
    func cardTapped(_ object: Any) {
        print("Tapped on: \(object)")
    }
    
    func reachedEndOfStack() {
        print("Reached end of stack")
    }
}

