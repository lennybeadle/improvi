//
//  ProgressTableViewCell.swift
//  ImprovI
//
//  Created by Macmini on 1/31/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

class ProgressTableViewCell: UITableViewCell {
    static let height: CGFloat = 70
    
    @IBOutlet weak var vwInnerView: SpringView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwInnerView.layer.borderColor = Constant.UI.foreColor.cgColor
        vwInnerView.layer.borderWidth = 1.0
        vwInnerView.layer.cornerRadius = 8
        vwInnerView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func resetWithDailyTask(task: DailyTask) {
        self.lblTitle.text = task.name
        self.lblDescription.text = task.longDescription
    }
}
