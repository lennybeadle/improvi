//
//  TBDViewController.swift
//  ImprovI
//
//  Created by Macmini on 1/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SpriteKit
import LTMorphingLabel
import Spring
import SVProgressHUD

class TBDViewController: BaseViewController {
    var vwEmitter: SKView!
    
    @IBOutlet weak var vwContainer: SpringView!
    var vwGraph: ScrollableGraphView!
    @IBOutlet weak var lblTotalIXP: SpringLabel!
    @IBOutlet weak var lblTraitPoints: SpringLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGraphView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTraits()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupEmitter()
    }

    func setupEmitter() {
        vwEmitter = SKView(frame: self.view.bounds)
        vwEmitter.allowsTransparency = true
        self.view.insertSubview(vwEmitter, at: 0)
        
        let scene = SKScene(size: vwEmitter.frame.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = UIColor.clear
        vwEmitter.presentScene(scene)
        
        if let path = Bundle.main.path(forResource: "starParticle", ofType: "sks") {
            if let emitter = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SKEmitterNode{
                emitter.targetNode = scene
                emitter.zPosition = 5
                emitter.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height - 100)
                scene.addChild(emitter)
            }
        }
    }
    
    func reloadTraits() {
        if let user = Manager.sharedInstance.currentUser {
            if user.traitPoints.count == 0 {
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
            else {
                self.showTraits()
            }
        }
    }
    
    func initGraphView() {
        let graphView = ScrollableGraphView(frame: self.vwContainer.bounds)
        graphView.backgroundFillColor = UIColor.clear
        
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
        if let user = Manager.sharedInstance.currentUser {
            self.lblTotalIXP.text = "\(user.totalIXP)"
            if user.traitPoints.count > 0 {
                let data: [Double] = user.traitPoints.map { return Double($0.value) }
                let labels = user.traitPoints.map { return $0.name! }
                let maxTrait = max(user.maxTraits, 30)
                vwGraph.rangeMax = Double(maxTrait - (maxTrait % 10) + 20)
                vwGraph.numberOfIntermediateReferenceLines = min(20, Int(vwGraph.rangeMax)/5 - 1)
                vwGraph.set(data: data, withLabels: labels)
                vwGraph.setNeedsLayout()
            }
            self.lblTraitPoints.text = "\(user.totalTP)"
        }
    }

    @IBAction func onPurchase(_ sender: Any) {
        let alert = UIAlertController(title: "Warnning", message: "Are you going to purchase 250 iXP with $0.99 USD?", preferredStyle: .alert)
        let btnYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            Manager.sharedInstance.purchaseIXP(completion: { (result) in
                self.lblTotalIXP.text = "\(Manager.sharedInstance.currentUser.totalIXP)"
            })
        })
        let btnNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(btnYes)
        alert.addAction(btnNo)
        self.present(alert, animated: true, completion: nil)
    }
}
