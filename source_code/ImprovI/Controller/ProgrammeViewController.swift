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
        return Manager.shared.allProgrammes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgrammeCell", for: indexPath) as! ProgrammeTableViewCell
        cell.resetWithProgramme(programme: Manager.shared.allProgrammes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let programme = Manager.shared.allProgrammes[indexPath.row]
        if !programme.unlocked {
            self.askUnlockWithFeather(feathers: programme.needed_feather, completion: { (feathers) in
                self.unlockProgramme(programme: programme)
            })
        }
        else {
            if Manager.shared.allTasks.count == 0 {
                self.alert(message: "Loading tasks... Please wait.")
                return
            }
            else {
                programme.getPrepared(with: Manager.shared.allTasks)
                self.performSegue(withIdentifier: "sid_programme_detail", sender: indexPath)
            }
        }
    }
    
    func unlockProgramme(programme: Programme) {
        if let availableFeathers = Manager.shared.currentUser.feathers, availableFeathers < programme.needed_feather {
            self.askPurchaseFeather(completion: { (feathers) in
                self.showPurchase()
            })
        }
        else {
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
            APIManager.unlockProgramme(userId: Manager.shared.currentUser.id, programmeId: programme.id, completion: { (result) in
                SVProgressHUD.dismiss()
                if result {
                    self.showMessage(title: "You have successfully unlocked the programme", text: "")
                    Manager.shared.currentUser.feathers = Manager.shared.currentUser.feathers - programme.needed_feather
                    programme.unlocked = true
                    self.tblProgrammes.reloadData()
                }
                else {
                    self.showMessage(title: "Failed to unlock the programme", text: "")
                }
            })
        }
    }
    
    func showPurchase() {
        self.performSegue(withIdentifier: "sid_feather", sender: self)
    }
}

extension ProgrammeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            let programme = Manager.shared.allProgrammes[indexPath.row]
            if let controller = segue.destination as? ProgrammeDetailViewController {
                controller.programme = programme
            }
        }
    }
}


