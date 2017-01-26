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
    @IBOutlet weak var lblName: SpringLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblName.layer.cornerRadius = 3
        self.lblName.layer.masksToBounds = true
    }
    
    func resetWithProgramme(programme: Programme) {
        self.lblName.text = programme.name        
    }
}
