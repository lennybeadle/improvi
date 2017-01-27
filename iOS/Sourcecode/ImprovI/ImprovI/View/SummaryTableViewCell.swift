//
//  SummaryTableViewCell.swift
//  ImprovI
//
//  Created by Macmini on 1/28/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

class SummaryTableViewCell: UITableViewCell {
    static let height: CGFloat = 80
    
    @IBOutlet weak var vwInnerView: SpringView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var cellIndex: Int!
    
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
    
    func resetWithImage(image: UIImage, title: String, index: Int) {
        self.imgIcon.image = image
        self.lblTitle.text = title
        self.cellIndex = index
    }
}
