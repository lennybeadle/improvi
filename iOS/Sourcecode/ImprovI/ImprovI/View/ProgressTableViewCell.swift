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
    static let height: CGFloat = 150
    
    @IBOutlet weak var vwInnerView: SpringView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var lblTimeRemaining: UILabel!
    @IBOutlet weak var lblStarted: UILabel!
    
    @IBOutlet weak var progressProgress: LinearProgressView!
    @IBOutlet weak var progressTime: LinearProgressView!
    
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
        
        let distance = Date.dateBetween(date1: task.startTime, date2: Date())
        if distance.day >= 1 {
            lblTitle.textColor = Constant.UI.foreColorHighlight
            lblTimeRemaining.textColor = Constant.UI.foreColorHighlight
            progressTime.barColor = Constant.UI.foreColorHighlight
            lblTimeRemaining.text = "Time over, Hurry up!"
        }
        else {
            lblTitle.textColor = Constant.UI.foreColor
            lblTimeRemaining.textColor = Constant.UI.foreColor
            progressTime.barColor = Constant.UI.foreColor
            if distance.day == 0 {
                lblTimeRemaining.text = "\(distance.hour) hour(s) \(distance.min) min(s)"
            }
            else {
                lblTimeRemaining.text = "\(distance.day) day(s) \(distance.hour) hour(s) \(distance.min) min(s)"
            }
        }
        
        lblStarted.text = "Started: \(task.startTime.year)/\(task.startTime.month)/\(task.startTime.day)"
        progressProgress.progressValue = task.progress()
        
        let minutes: CGFloat = ( Date.daysBetween(date1: task.startTime, date2: Date()) > 0 ? 0.0: CGFloat(Date.minutesBetween(date1: task.startTime, date2: Date())) )
        progressTime.progressValue = CGFloat(100 - minutes/1440.0*100.0)
        self.lblProgress.text = "\(Int(progressProgress.progressValue))%"
    }
}
