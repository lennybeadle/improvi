//
//  TraitPointTableViewCell.swift
//  ImprovI
//
//  Created by Macmini on 1/31/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

class TraitPointTableViewCell: UITableViewCell {
    static let height: CGFloat = 44

    @IBOutlet weak var vwInnerView: SpringView!
    @IBOutlet weak var progressView: LinearProgressView!
    @IBOutlet weak var lblTraitPoints: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func resetWithTitle(title: String, progress: CGFloat) {
        self.progressView.progressValue = progress
        self.lblTraitPoints.text = title + ": \(Int(progress))%"
    }
}
