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

        self.programmes = Manager.sharedInstance.allProgrammes
    }
}


extension ProgressViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return programmes.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = programmes[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(collapsed: programmes[section].collapsed)
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if programmes[indexPath.section].collapsed {
            return 0
        }
        else {
            return ProgressTableViewCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.programmes[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressCell", for: indexPath)
        
        if let customCell = cell as? ProgressTableViewCell {
            let programme = programmes[indexPath.section]
            customCell.resetWithDailyTask(task: programme.tasks[indexPath.row])
            
            if isAnimated == false {
                customCell.vwInnerView.delay = 0.05*CGFloat(indexPath.row)
                customCell.vwInnerView.animate()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblProgress.beginUpdates()
        for i in 0 ..< programmes[indexPath.section].tasks.count {
            tblProgress.reloadRows(at: [IndexPath(row: i, section: indexPath.section)], with: .automatic)
        }
        tblProgress.endUpdates()
    }
}

extension ProgressViewController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = programmes[section].collapsed
        
        // Toggle collapse
        programmes[section].collapsed = !collapsed
        header.setCollapsed(collapsed: !collapsed)
        
        // Adjust the height of the rows inside the section
        tblProgress.beginUpdates()
        for i in 0 ..< programmes[section].tasks.count {
            tblProgress.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tblProgress.endUpdates()
    }
}
