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

    func resetWithAnswer(answer: Answer, selected: Bool, editable: Bool = true) {
        if editable {
            checkBox.containerColor = Constant.UI.foreColor
        }
        else {
            checkBox.containerColor = Constant.UI.foreColorHighlight
        }
        lblAnswer.text = answer.content
        checkBox.on = selected
    }
}
