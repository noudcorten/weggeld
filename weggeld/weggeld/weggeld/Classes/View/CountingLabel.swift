//
//  CountingLabel.swift
//  WegGeld
//
//  Created by Noud on 6/11/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {
    let appData = AppData.loadAppData()
    
    let counterVelocity: Float = 3.0
    
    enum CounterAnimationType {
        case Linear
        case EaseIn
        case EaseOut
    }
    
    enum CounterType {
        case Int
        case Float
    }
    
    var startNumber: Float = 0.0
    var endNumber: Float = 0.0
    
    var progress: TimeInterval!
    var duration: TimeInterval!
    var lastUpdate: TimeInterval!
    
    var timer: Timer?
    
    var counterType: CounterType!
    var counterAnimationType: CounterAnimationType!
    
    var currentCounterValue: Float {
        if progress >= duration {
            return endNumber
        }
        
        let percentage = Float(progress / duration)
        let update = updateCounter(counterValue: percentage)
        return endNumber - (update * (endNumber - startNumber))
    }
    
    func count(from fromValue: Float, to toValue: Float) {
        
        self.startNumber = fromValue
        self.endNumber = toValue
        self.duration = 3
        self.counterType = .Int
        self.counterAnimationType = .EaseOut
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        
        invalidateTimer()
        
        if duration == 0 {
            updateText(value: toValue)
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CountingLabel.updateValue), userInfo: nil, repeats: true)
    }
    
    @objc func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        
        if progress >= duration {
            invalidateTimer()
            progress = duration
        }
        
        updateText(value: currentCounterValue)
    }
    
    func updateText(value: Float) {
        switch counterType! {
        case .Int:
            self.text = "\(Int(value)) %"
        case .Float:
            self.text = String(format: "%.2f", value)
        }
    }
    
    func updateCounter(counterValue: Float) -> Float {
        switch counterAnimationType! {
        case .Linear:
            return counterValue
        case .EaseIn:
            return powf(counterValue, counterVelocity)
        case.EaseOut:
            return powf(1.0 - counterValue, counterVelocity)
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
