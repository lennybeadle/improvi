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
    static let height: CGFloat = 60

    @IBOutlet weak var vwInnerView: SpringView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var progressView: LinearProgressView!
    @IBOutlet weak var lblTraitPoints: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func resetWithTitle(title: String, progress: CGFloat) {
        self.lblTitle.text = title
        self.progressView.progressValue = progress
        self.lblTraitPoints.text = "\(Int(progress))"
    }
}
