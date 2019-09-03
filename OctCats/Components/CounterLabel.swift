//
//  CounterLabel.swift
//  OctCats
//
//  Created by arabian9ts on 2019/08/28.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import UIKit

class CounterLabel: UILabel {
    private let duration = 1.0
    private let startedAt = Date()
    private var timer: Timer?
    private var value: Double = 0
    private var from: Double = 0
    private var to: Double = 0
    
    func startCount(from: Double, to: Double) {
        if let _ = timer { return }
        self.value = from
        self.from = from
        self.to = to
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.05,
            target: self,
            selector: #selector(updateValue),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func updateValue() {
        if to <= value {
            text = "\(Int(to))"
            stopAnimation()
            return
        }
        let now = Date()
        let elapsed = now.timeIntervalSince(startedAt)
        let per = elapsed / duration
        value = (to - from) * per
        text = "\(Int(value))"
    }
    
    func stopAnimation() {
        timer?.invalidate()
    }
}
