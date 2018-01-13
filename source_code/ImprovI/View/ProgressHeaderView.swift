//
//  ProgressHeaderView.swift
//  ImprovI
//
//  Created by Macmini on 2/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

protocol ProgressHeaderViewDelegate {
    func toggleSection(header: ProgressHeaderView, section: Int)
}

class ProgressHeaderView: UITableViewHeaderFooterView {
    var delegate: ProgressHeaderViewDelegate?
    var section: Int = 0
    
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    
    let progressLabel = UILabel()
    let timeLabel = UILabel()
    
    let progressProgress = LinearProgressView()
    let progressTime = LinearProgressView()
    
    var collapsed: Bool!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Constant.UI.foreColor.withAlphaComponent(0.9)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowLabel)
        contentView.addSubview(progressLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(progressProgress)
        contentView.addSubview(progressTime)
        
        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        titleLabel.textColor = Constant.UI.backColor
        arrowLabel.textColor = Constant.UI.backColor
        progressLabel.textColor = Constant.UI.backColor
        progressLabel.textAlignment = .right
        timeLabel.textColor = Constant.UI.backColor
        timeLabel.textAlignment = .right
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        progressLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        
        progressProgress.barColor = Constant.UI.foreColorLight
        progressProgress.trackColor = Constant.UI.backColorLight
        progressProgress.barThickness = 8
        progressProgress.trackPadding = 2
        progressProgress.backgroundColor = UIColor.clear
        
        progressTime.barColor = Constant.UI.foreColorLight
        progressTime.trackColor = Constant.UI.backColorLight
        progressTime.barThickness = 8
        progressTime.trackPadding = 2
        progressTime.backgroundColor = UIColor.clear
        
        progressProgress.widthAnchor.constraint(equalToConstant: 10).isActive = true
        progressProgress.heightAnchor.constraint(equalToConstant: 10).isActive = true

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        progressProgress.translatesAutoresizingMaskIntoConstraints = false
        progressTime.translatesAutoresizingMaskIntoConstraints = false
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProgressHeaderView.tapHeader(gestureRecognizer:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? ProgressHeaderView else {
            return
        }
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func setCollapsed(collapsed: Bool) {
        arrowLabel.rotate(toValue: collapsed ? 0.0 : CGFloat(Double.pi/2))
    }
    
    func resetWithProgramme(programme: Programme) {
        self.titleLabel.text = programme.name
        self.arrowLabel.text = ">"

        if programme.countOfWorkingTasks + programme.countOfCompletedTasks + programme.countOfTimeOverredTask == 0 {
            contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        else {
            contentView.backgroundColor = Constant.UI.foreColor.withAlphaComponent(0.9)
        }
        

        if programme.status == .timeover {
            progressTime.barColor = UIColor.darkGray
        }
        else {
            progressTime.barColor = Constant.UI.foreColorLight
        }
        
        timeLabel.text = programme.timeString
        progressLabel.text = "Progress: \(Int(programme.progress))%"
        progressProgress.progressValue = programme.progress
        progressTime.progressValue = programme.timeProgress
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let views = [
            "titleLabel" : titleLabel,
            "arrowLabel" : arrowLabel,
            "progressLabel" : progressLabel,
            "timeLabel" : timeLabel,
            "progressProgress" : progressProgress,
            "progressTime" : progressTime
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[titleLabel]-[arrowLabel]-20-|",
            options: [],
            metrics: nil,
            views: views
        ))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[progressLabel]-20-|",
            options: [],
            metrics: nil,
            views: views
        ))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[timeLabel]-20-|",
            options: [],
            metrics: nil,
            views: views
        ))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[progressProgress]-20-|",
            options: [],
            metrics: nil,
            views: views
        ))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[progressTime]-20-|",
            options: [],
            metrics: nil,
            views: views
        ))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[titleLabel(20)]-10-[progressLabel(20)]-5-[progressProgress(10)]-10-[timeLabel(20)]-5-[progressTime(10)]",
            options: [],
            metrics: nil,
            views: views
        ))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[arrowLabel(20)]",
            options: [],
            metrics: nil,
            views: views
        ))
    }
}
