//
//  CountingLabel.swift
//  WegGeld
//
//  Created by Noud on 6/11/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* Label Class which is used in the MoneyViewController. This Class adds the
animation for the precentage label counting up. */
class CountingLabel: UILabel {
    // Initialization of used constants.
    let appData = AppData.loadAppData()
    let duration: TimeInterval! = 3
    let counterVelocity: Float = 3.0
    
    // Initialization of used variables.
    var startNumber: Float!
    var endNumber: Float!
    var progress: TimeInterval!
    var timer: Timer?
    var lastUpdate: TimeInterval!
    
    // Calculates the current value thats needs to be represented
    var currentCounterValue: Float {
        if progress >= duration {
            return endNumber
        }
        
        let percentage = Float(progress / duration)
        let update = updateCounter(counterValue: percentage)
        return endNumber - (update * (endNumber - startNumber))
    }
    
    /// Function used for the counting up animation.
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
    
    /// Function which is called from the MoneyViewController which starts the
    /// animation between the two given values.
    func count(from fromValue: Float, to toValue: Float) {
        self.startNumber = fromValue
        self.endNumber = toValue
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        
        invalidateTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CountingLabel.updateValue), userInfo: nil, repeats: true)
    }
    
    /// Function which updates the text of the label.
    private func updateText(value: Float) {
        self.text = "\(Int(value)) %"
    }
    
    /// Function which determines the animation of the counting.
    private func updateCounter(counterValue: Float) -> Float {
        return powf(1.0 - counterValue, counterVelocity)
    }
    
    /// Invalidates the timer when needed.
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
