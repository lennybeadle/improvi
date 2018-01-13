//
//  CongratsTableViewCell.swift
//  ImprovI
//
//  Created by Macmini on 2/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class CongratsTableViewCell: UITableViewCell {
    static let height: CGFloat = 44

    @IBOutlet weak var lblTrait: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func reset(with trait: TraitPoint) {
        //self.lblTrait.font
        let str = NSMutableAttributedString(string: "+ \(Int(trait.value)) ", attributes: [NSAttributedStringKey.font: self.lblTrait.font, NSAttributedStringKey.foregroundColor: Constant.UI.foreColor])
        str.append(NSAttributedString(string: trait.name.uppercased(), attributes: [NSAttributedStringKey.font: self.lblTrait.font, NSAttributedStringKey.foregroundColor: Constant.UI.foreColorLight]))
        str.append(NSAttributedString(string: " Pnts", attributes: [NSAttributedStringKey.font: self.lblTrait.font, NSAttributedStringKey.foregroundColor: Constant.UI.foreColor]))
        self.lblTrait.attributedText = str
    }
}
