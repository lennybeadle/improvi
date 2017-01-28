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
    let titles = ["Profile", "Progress", "Trait Points", "Settings"]
    let imageNames = ["icon_profile", "icon_progress", "icon_traitpoints", "icon_settings"]
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
        
    }
}
