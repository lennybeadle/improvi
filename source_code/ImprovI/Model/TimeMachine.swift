
//
//  TimeMachine.swift
//  ImprovI
//
//  Created by Macmini on 4/11/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
protocol TimeDelegate: class {
    func timeUpdated(period: Double)
}

class TimeMachine {
    static let shared: TimeMachine = TimeMachine()

    var timer: Timer?
    var observers: [TimeDelegate] = []
    var interval: TimeInterval = 1.0 {
        didSet {
            self.setup()
        }
    }
    
    init() {
        setup()
    }
    
    func setup() {
        if let timer = self.timer {
            timer.invalidate()
        }
       
        self.timer = Timer.scheduledTimer(withTimeInterval: self.interval, repeats: true) { (timer) in
            for delegate in self.observers {
                delegate.timeUpdated(period: self.interval)
            }
        }
    }
    
    func addObserver(_ observer: TimeDelegate) {
        self.removeObserver(observer)
        self.observers.append(observer)
    }
    
    func removeObserver(_ observer: TimeDelegate) {
        if let index = observers.index(where: { $0 === observer }) {
            self.observers.remove(at: index)
        }
    }
}
