//
//  AnswerTableViewCell.swift
//  ImprovI
//
//  Created by Macmini on 1/29/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Spring

class AnswerTableViewCell: UITableViewCell {
    static let height: CGFloat = 60

    @IBOutlet weak var vwInnerView: SpringView!
    @IBOutlet weak var checkBox: CheckboxButton!
    @IBOutlet weak var lblAnswer: SpringLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func resetWithAnswer(answer: String, selected: Bool) {
        lblAnswer.text = answer
        checkBox.on = selected
    }
}
