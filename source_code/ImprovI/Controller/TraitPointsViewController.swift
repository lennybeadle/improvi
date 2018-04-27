//
//  TraitPointsViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD
import Spring

class TraitPointsViewController: BaseViewController {
    @IBOutlet weak var vwContainer: SpringView!
    var vwGraph: ScrollableGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGraphView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTraits()
    }
    
    func reloadTraits() {
        if let user = Manager.shared.currentUser {
            user.traitPoints.removeAll()
            SVProgressHUD.show(withStatus: Constant.Keyword.loading)
            APIManager.loadTraits(userId: user.id, completion: { (traits, ixpval) in
                SVProgressHUD.dismiss()
                if let traits = traits {
                    user.traitPoints.append(contentsOf: traits)
                }
                user.totalIXP = ixpval
                DispatchQueue.main.async {
                    self.showTraits()
                }
            })            
        }
    }
    
    func initGraphView() {
        let graphView = ScrollableGraphView(frame: self.vwContainer.bounds)
        graphView.backgroundFillColor = Constant.UI.backColor
        
        // Disable the lines and data points.
        graphView.shouldDrawDataPoint = false
        graphView.lineColor = UIColor.clear
        
        // Tell the graph it should draw the bar layer instead.
        graphView.shouldDrawBarLayer = true
        
        // Customise the bar.
        graphView.barWidth = 50
        graphView.barLineWidth = 1
        graphView.barLineColor = Constant.UI.foreColor
        graphView.barColor = Constant.UI.foreColor.withAlphaComponent(0.5)
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        graphView.referenceLineColor = Constant.UI.foreColor.withAlphaComponent(0.5)
        graphView.referenceLineLabelColor = Constant.UI.foreColor
        graphView.dataPointLabelColor = Constant.UI.foreColor
        graphView.dataPointSpacing = 80
        
        graphView.shouldAnimateOnStartup = true
        graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        graphView.animationDuration = 0.5
        graphView.shouldRangeAlwaysStartAtZero = true
        vwContainer.addSubview(graphView)
        
        self.vwGraph = graphView
        let views = [
            "graphView" : graphView
        ]
        graphView.translatesAutoresizingMaskIntoConstraints = false

        vwContainer.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[graphView]-|",
            options: [],
            metrics: nil,
            views: views
        ))
        
        vwContainer.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[graphView]-|",
            options: [],
            metrics: nil,
            views: views
        ))
    }

    func showTraits() {
        if let user = Manager.shared.currentUser {
            if user.traitPoints.count > 0 {
                var data = [Double]()
                var labels = [String]()
                let maxTrait = max(user.maxTraits, 30)
                for trait in user.traitPoints {
                    if trait.value == 0 {
                        continue
                    }
                    data.append(Double(trait.value!))
                    labels.append(trait.name)
                }
                vwGraph.rangeMax = Double(maxTrait - (maxTrait % 10) + 20)
                vwGraph.numberOfIntermediateReferenceLines = min(20, Int(vwGraph.rangeMax)/5 - 1)
                vwGraph.set(data: data, withLabels: labels)
                vwGraph.setNeedsLayout()
            }
        }
    }
    
//    func showTraits() {
//        if let user = Manager.sharedInstance.currentUser {
//            if user.traitPoints.count > 0 {
//
//                let data: [Double] = user.traitPoints.map { return Double($0.value) }
//                let labels = user.traitPoints.map { return $0.name! }
//                let maxTrait = max(user.maxTraits, 30)
//                vwGraph.rangeMax = Double(maxTrait - (maxTrait % 10) + 20)
//                vwGraph.numberOfIntermediateReferenceLines = min(20, Int(vwGraph.rangeMax)/5 - 1)
//                vwGraph.set(data: data, withLabels: labels)
//                vwGraph.setNeedsLayout()
//            }
//        }
//    }
}
