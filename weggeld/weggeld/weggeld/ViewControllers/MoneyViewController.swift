//
//  MoneyViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class MoneyViewController: UIViewController {

    
    @IBOutlet weak var countingLabel: CountingLabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var maxAmountLabel: UILabel!
    
    @IBOutlet weak var toSpendLabel: UILabel!
    @IBOutlet weak var spendedLabel: UILabel!
    @IBOutlet weak var moneyToSpendLabel: UILabel!
    @IBOutlet weak var moneySpendedLabel: UILabel!
    
    var appData: AppData?
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    private func createLoadCircle(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.position = view.center
        return layer
    }
    
    private func setupNotificationsObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification , object: nil)
    }
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        setupNotificationsObserver()
        
        if let appData = AppData.loadAppData() {
            AppData.saveAppData(appData)
        } else {
            let appData = AppData(expenses: [], maxAmount: 10.0)
            AppData.saveAppData(appData)
            
        }
        
        appData = AppData.loadAppData()
        
        updateMoneyLabels()
        setUpCircleLayers()
        updatePercentageAnimations()
    }
    
    
    
    private func setUpCircleLayers() {
        // Create pulsating layer
        pulsatingLayer = createLoadCircle(strokeColor: .clear, fillColor: UIColor.pullsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        // Create track layer
        let trackLayer = createLoadCircle(strokeColor: .trackStrokeColor, fillColor: .white)
        view.layer.addSublayer(trackLayer)
        
        // Create circle layer
        shapeLayer = createLoadCircle(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    private func updatePercentageAnimations() {
        view.addSubview(countingLabel)
        
        var percentage: Float = (appData!.totalExpense() / appData!.maxAmount)
        if percentage > 1 {
            percentage = 1
        }
        countingLabel.count(from: 0, to: percentage * 100, withDuration: 3, andAnimationType: .EaseOut, andCounterType: .Int)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = CGFloat(percentage)
        basicAnimation.duration = 3
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.2
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    private func updateMoneyLabels() {
        if appData!.totalExpense() > appData!.maxAmount {
            moneyLabel.textColor = UIColor.red
        } else {
            moneyLabel.textColor = UIColor.black
        }
        
        toSpendLabel.text = "Nog te besteden:"
        let moneyLeft = appData!.maxAmount - appData!.totalExpense()
        if floor(moneyLeft) == moneyLeft {
            moneyLabel.text = "€ \(Int(moneyLeft))"
            moneyToSpendLabel.text = "€\(Int(moneyLeft))"
        } else {
            moneyLabel.text = "€\(moneyLeft)"
            moneyToSpendLabel.text = "€\(moneyLeft)"
        }
        
        spendedLabel.text = "Uitgegeven:"
        let moneySpended = appData!.totalExpense()
        if floor(moneySpended) == moneySpended {
            moneySpendedLabel.text = "€\(Int(moneySpended))"
        } else {
            moneySpendedLabel.text = "€\(moneySpended)"
        }
        
        maxAmountLabel.textColor = .gray
        let maxAmount = appData!.maxAmount
        if floor(maxAmount) == maxAmount {
            maxAmountLabel.text = "Totaal: €\(Int(maxAmount))"
        } else {
            maxAmountLabel.text = "Totaal: €\(maxAmount)"
        }
    }
    
    @IBAction func unwindToController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ExpenseTableViewController
        
        if let expense = sourceViewController.expense {
            appData!.addExpense(expense: expense)
            AppData.saveAppData(appData!)
        }
    }
        
        
}
