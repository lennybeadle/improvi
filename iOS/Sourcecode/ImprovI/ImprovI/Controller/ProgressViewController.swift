//
//  ProgressViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ProgressViewController: BaseViewController {
    @IBOutlet weak var tblProgress: UITableView!
    var programmes: [Programme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Manager.sharedInstance.sortProgrammes()
        self.programmes = Manager.sharedInstance.allProgrammes
        
        tblProgress.estimatedRowHeight = 70
        tblProgress.rowHeight = UITableViewAutomaticDimension
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
            return self.programmes[section].availableTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressCell", for: indexPath)
        
        if let customCell = cell as? ProgressTableViewCell {
            let programme = programmes[indexPath.section]
            customCell.resetWithDailyTask(task: programme.availableTasks[indexPath.row])
            
            if isAnimated == false {
//                customCell.vwInnerView.delay = 0.05*CGFloat(indexPath.row)
//                customCell.vwInnerView.animate()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblProgress.beginUpdates()
        for i in 0 ..< programmes[indexPath.section].availableTasks.count {
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
