//
//  ProgressViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProgressViewController: BaseViewController {
    @IBOutlet weak var tblProgress: UITableView!
    var programmes: [Programme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Manager.sharedInstance.sortProgrammes()
        self.programmes = Manager.sharedInstance.allProgrammes
        
        tblProgress.estimatedRowHeight = 70
        tblProgress.rowHeight = UITableViewAutomaticDimension
        
        self.loadProgress()
    }
    
    func program(for id: String) -> Programme? {
        if self.programmes == nil {
            return nil
        }
        
        for programme in self.programmes {
            if programme.id == id {
                return programme
            }
        }
        return nil
    }
    
    func loadProgress() {
        SVProgressHUD.show(withStatus: Constant.Keyword.loading)
        APIManager.getProgress(userId: Manager.sharedInstance.currentUser.id) { (progressDict) in
            SVProgressHUD.dismiss()
            if let dict = progressDict {
                for (id, value) in dict {
                    if let programme = self.program(for: id) {
                        let valueDict = value as! [String: Any]
                        let tasks = valueDict["tasks"] as! [Any]
                        programme.getPrepared(with: Manager.sharedInstance.allTasks)
                        programme.applyTaskStatus(with: tasks)                        
                    }
                }
                self.tblProgress.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tblProgress.reloadData()
    }
}


extension ProgressViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return programmes.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? ProgressHeaderView ?? ProgressHeaderView(reuseIdentifier: "header")
        
        header.resetWithProgramme(programme: programmes[section])
        header.setCollapsed(collapsed: programmes[section].collapsed)
        header.section = section
        header.delegate = self
        header.clipsToBounds = true
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84 //130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if programmes[section].collapsed {
            return 0
        }
        else {
            return self.programmes[section].programTasks(except: .locked).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressCell", for: indexPath)
        
        if let customCell = cell as? ProgressTableViewCell {
            let programme = programmes[indexPath.section]
            customCell.resetWithDailyTask(task: programme.programTasks(except: .locked)[indexPath.row])
            
            if isAnimated == false {
//                customCell.vwInnerView.delay = 0.05*CGFloat(indexPath.row)
//                customCell.vwInnerView.animate()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblProgress.beginUpdates()
        for i in 0 ..< programmes[indexPath.section].programTasks(except: .locked).count {
            tblProgress.reloadRows(at: [IndexPath(row: i, section: indexPath.section)], with: .automatic)
        }
        tblProgress.endUpdates()
    }
}

extension ProgressViewController: ProgressHeaderViewDelegate {
    func toggleSection(header: ProgressHeaderView, section: Int) {
        let collapsed = programmes[section].collapsed
        
        // Toggle collapse
        programmes[section].collapsed = !collapsed
        header.setCollapsed(collapsed: !collapsed)
        
        self.tblProgress.reloadSections([section], with: .automatic)
    }
}
