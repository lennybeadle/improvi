//
//  SummaryViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class SummaryViewController: BaseViewController {
    @IBOutlet weak var tblList: UITableView!
    let titles = ["Profile", "Progress", "My Summari", "Feathers & iXP"]
    let imageNames = ["icon_profile", "icon_progress", "icon_traitpoints", "icon_feather_white"]
    let itemCount = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SummaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SummaryTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath)
        if let customCell = cell as? SummaryTableViewCell {
            customCell.resetWithImage(image: UIImage(named: imageNames[indexPath.row])!, title: titles[indexPath.row], index: indexPath.row)
            
            if isAnimated == false {
                customCell.vwInnerView.delay = 0.05*CGFloat(indexPath.row)
                customCell.vwInnerView.animate()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "sid_profile", sender: self)
                break
            case 1:
                self.performSegue(withIdentifier: "sid_progress", sender: self)
                break
            case 2:
                self.performSegue(withIdentifier: "sid_tbd", sender: self)
                break
            case 3:
                self.performSegue(withIdentifier: "sid_feather", sender: self)
                break
            default:
                break
        }
    }
}
