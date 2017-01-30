//
//  TraitPointsViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class TraitPointsViewController: BaseViewController {

    @IBOutlet weak var tblTraitPoints: UITableView!
    var traitPoints = [String: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 1...10 {
            traitPoints["Trait \(i)"] = CGFloat(arc4random_uniform(100))
        }
        
        tblTraitPoints.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TraitPointsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TraitPointTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return traitPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TraitPointCell", for: indexPath)
        if let customCell = cell as? TraitPointTableViewCell {
//            customCell.resetWithTitle(title: traitPoints[indexPath.row].key, progress: traitPoints[indexPath.row].value)
            customCell.resetWithTitle(title: "Trait \(indexPath.row+1)", progress: traitPoints["Trait \(indexPath.row+1)"]!)
            
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
