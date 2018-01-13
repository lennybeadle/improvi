//
//  ProgrammeViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProgrammeViewController: BaseViewController {
    @IBOutlet weak var tblProgrammes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblProgrammes.reloadData()
    }
}

extension ProgrammeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Manager.sharedInstance.allProgrammes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgrammeCell", for: indexPath) as! ProgrammeTableViewCell
        cell.resetWithProgramme(programme: Manager.sharedInstance.allProgrammes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let programme = Manager.sharedInstance.allProgrammes[indexPath.row]
        if !programme.unlocked {
            self.alert(message: "This programme is locked. Are you going to unlock with \(programme.needed_feather) feathers?", title: "", options: "Yes", "No", completion: { (index) in
                if index == 0 { //means Yes button
                    self.unlockProgramme(programme: programme)
                }
            })
        }
        else {
            if Manager.sharedInstance.allTasks.count == 0 {
                self.alert(message: "Loading tasks... Please wait.")
                return
            }
            else {
                programme.getPrepared(with: Manager.sharedInstance.allTasks)
                self.performSegue(withIdentifier: "sid_programme_detail", sender: indexPath)
            }
        }
    }
    
    func unlockProgramme(programme: Programme) {
        if let availableFeathers = Manager.sharedInstance.currentUser.feathers, availableFeathers < programme.needed_feather {
            self.alert(message: "No enough feathers. Would you purchase featheres?", title: "", options: "Yes", "No", completion: { (index) in
                if index == 0 { //means Yes button
                    self.showPurchase()
                }
            })
        }
    }
    
    func showPurchase() {
        
    }
}

extension ProgrammeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            let programme = Manager.sharedInstance.allProgrammes[indexPath.row]
            if let controller = segue.destination as? ProgrammeDetailViewController {
                controller.programme = programme
            }
        }
    }
}


