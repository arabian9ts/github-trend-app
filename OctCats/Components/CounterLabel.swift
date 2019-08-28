//
//  CounterLabel.swift
//  OctCats
//
//  Created by arabian9ts on 2019/08/28.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import UIKit

class CounterLabel: UILabel {
    private var timer: Timer?
    private var value: Int = 0
    private var from: Int = 0
    private var to: Int = 0
    
    func startCount(from: Int, to: Int) {
        self.value = from
        self.from = from
        self.to = to
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(updateValue),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func updateValue() {
        if self.to <= self.value {
            stopAnimation()
            return
        }
        self.value += 1
        self.text = "\(self.value)"
    }
    
    func stopAnimation() {
        self.timer?.invalidate()
    }
}
