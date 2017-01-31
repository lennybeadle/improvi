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

class TBDViewController: BaseViewController {
    var vwEmitter: SKView!
    @IBOutlet weak var lblIXPPoints: LTMorphingLabel!
    @IBOutlet weak var lblTraitPoints: LTMorphingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblIXPPoints.morphingEffect = .fall
        self.lblTraitPoints.morphingEffect = .evaporate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupEmitter()
        self.showPoints(show: true)
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
    
    func showPoints(show: Bool) {
        if show {
            self.lblIXPPoints.text = "300"
            self.lblTraitPoints.text = "200"
        }
        else {
            self.lblIXPPoints.text = "Awesome"
            self.lblTraitPoints.text = "Great"
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.showPoints(show: !show)
        }
    }
}
