//
//  ProgrammeTableViewCell.swift
//  ImprovI
//
//  Created by Macmini on 1/27/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

class ProgrammeTableViewCell: UITableViewCell {
    @IBOutlet weak var vwInnerView: SpringView!
    @IBOutlet weak var lblName: SpringLabel!
    weak var programme: Programme!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwInnerView.layer.cornerRadius = 30
        self.vwInnerView.layer.masksToBounds = false
        
        self.vwInnerView.layer.borderWidth = 1
        self.vwInnerView.layer.borderColor = Constant.UI.foreColor.cgColor
        
        self.vwInnerView.layer.shadowColor = UIColor.gray.cgColor
        self.vwInnerView.layer.shadowOpacity = 0.5
        self.vwInnerView.layer.shadowRadius = 2
        self.vwInnerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func resetWithProgramme(programme: Programme) {
        self.programme = programme
        self.lblName.text = programme.name        
    }
}
