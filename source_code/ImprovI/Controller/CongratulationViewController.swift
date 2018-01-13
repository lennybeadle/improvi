//
//  CongratulationViewController.swift
//  ImprovI
//
//  Created by Macmini on 2/15/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SpriteKit

class CongratulationViewController: UIViewController {
    var vwEmitter: SKView!
    var emitter: SKEmitterNode!
    weak var task: DailyTask!
    @IBOutlet weak var tblTraits: UITableView!
    @IBOutlet weak var lblIXP: UILabel!
    @IBOutlet weak var tblHeightContraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.task != nil {
            self.lblIXP.text = "+ \(self.task.boostPoint!) IXP"
            tblHeightContraints.constant = CongratsTableViewCell.height * CGFloat(self.task.traitPoints.count)
            self.tblTraits.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupEmitter()
        
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CongratulationViewController.disappear)))
    }
    
    @objc func disappear() {
        self.emitter.particleBirthRate = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
        }) { (result) in
            super.dismiss(animated: false, completion: nil)
        }
    }
    
    func setupEmitter() {
        vwEmitter = SKView(frame: self.view.bounds)
        vwEmitter.allowsTransparency = true
        self.view.insertSubview(vwEmitter, at: 1)
        
        let scene = SKScene(size: vwEmitter.frame.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = UIColor.clear
        vwEmitter.presentScene(scene)
        
        if let path = Bundle.main.path(forResource: "congratulation", ofType: "sks") {
            if let emitter = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SKEmitterNode{
                emitter.targetNode = scene
                emitter.zPosition = 5
                emitter.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height*0.75)
                self.emitter = emitter
                scene.addChild(emitter)
            }
        }
    }
}

extension CongratulationViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CongratsTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.task.traitPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TraitCell", for: indexPath)
        if let customCell = cell as? CongratsTableViewCell {
            customCell.reset(with: self.task.traitPoints[indexPath.row])
        }
        return cell
    }
}
