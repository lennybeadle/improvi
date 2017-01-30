//
//  SettingsTableViewCell.swift
//  ImprovI
//
//  Created by Macmini on 1/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

class SettingsTableViewCell: UITableViewCell {
    static let height: CGFloat = 44

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgAccessory: UIImageView!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwInnerView: SpringView!
    
    var isAccessory: Bool = true {
        didSet {
            if isAccessory {
                trailingConstraint.constant = 26
                imgAccessory.isHidden = false
                
            }
            else {
                trailingConstraint.constant = 10
                imgAccessory.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resetWithTitle(title: String, detail: String) {
        self.lblTitle.text = title
        self.lblDescription.text = detail
    }
}
