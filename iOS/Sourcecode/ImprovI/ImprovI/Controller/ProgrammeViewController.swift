//
//  ProgrammeViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

enum SectionType: Int {
    case inProgress = 0
    case available = 1
}

class ProgrammeViewController: BaseViewController {
    @IBOutlet weak var tblProgrammes: UITableView!
    var dragger: TableViewDragger!
    var availableProgrammes = [Programme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragger = TableViewDragger(tableView: tblProgrammes)
        dragger.dataSource = self
        dragger.delegate = self
        dragger.cellZoomScale = 0.9
        dragger.cellAlpha = 0.7
        
        initAvailableProgrammes()
    }
    
    func initAvailableProgrammes() {
        let manager = Manager.sharedInstance
        
        for prgm in manager.allProgrammes {
            if manager.currentUser.hasProgramme(prgm) == false {
                self.availableProgrammes.append(prgm)
            }
        }
        self.tblProgrammes.reloadData()
    }
}

extension ProgrammeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SectionType.inProgress.rawValue {
            return "In Progress:"
        }
        else {
            return "Add Programme:"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.inProgress.rawValue {
            return Manager.sharedInstance.currentUser.programmes.count
        }
        else {
            return self.availableProgrammes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgrammeCell", for: indexPath)
        if let customCell = cell as? ProgrammeTableViewCell {
            if indexPath.section == SectionType.inProgress.rawValue {
                customCell.resetWithProgramme(programme: Manager.sharedInstance.currentUser.programmes[indexPath.row])
            }
            else {
                customCell.resetWithProgramme(programme: availableProgrammes[indexPath.row])
            }
            if isAnimated == false {
                customCell.vwInnerView.delay = 0.05*CGFloat(Manager.sharedInstance.currentUser.programmes.count*indexPath.section) + 0.05*CGFloat(indexPath.row)
                customCell.vwInnerView.animate()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension ProgrammeViewController: TableViewDraggerDataSource, TableViewDraggerDelegate {
    func dragger(_ dragger: TableViewDragger, shouldDragAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }

    func dragger(_ dragger: TableViewDragger, moveDraggingAtIndexPath indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        if indexPath.section == newIndexPath.section {
            if indexPath.section == SectionType.available.rawValue{
                swap(&availableProgrammes[(indexPath as NSIndexPath).row], &availableProgrammes[(newIndexPath as NSIndexPath).row])
            }
            else {
                swap(&Manager.sharedInstance.currentUser.programmes[(indexPath as NSIndexPath).row], &Manager.sharedInstance.currentUser.programmes[(newIndexPath as NSIndexPath).row])
            }
            self.tblProgrammes.moveRow(at: indexPath, to: newIndexPath)
        }
        else {
            if newIndexPath.section == SectionType.available.rawValue {
                let programme = Manager.sharedInstance.currentUser.programmes!.remove(at: indexPath.row)
                self.availableProgrammes.insert(programme, at: newIndexPath.row)
            }
            else {
                let programme = self.availableProgrammes.remove(at: indexPath.row)
                Manager.sharedInstance.currentUser.programmes.insert(programme, at: newIndexPath.row)
            }
            self.tblProgrammes.moveRow(at: indexPath, to: newIndexPath)
        }
        return true
    }
}

extension ProgrammeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let programmeCell = sender as? ProgrammeTableViewCell {
            if let controller = segue.destination as? ProgrammeDetailViewController {
                controller.programme = programmeCell.programme
            }
        }
    }
}


