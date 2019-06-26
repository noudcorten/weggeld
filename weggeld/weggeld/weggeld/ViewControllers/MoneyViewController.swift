//
//  MoneyViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* Class which controls the view of the first tab bar screen. This screen shows
the amount of progress the user has made in terms of expenses. */
class MoneyViewController: UIViewController {
    
    // MARK: - Initialization of the IBOutlets.
    @IBOutlet weak var countingLabel: CountingLabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var maxAmountLabel: UILabel!
    @IBOutlet weak var toSpendLabel: UILabel!
    @IBOutlet weak var spendedLabel: UILabel!
    @IBOutlet weak var moneyToSpendLabel: UILabel!
    @IBOutlet weak var moneySpendedLabel: UILabel!
    
    @IBAction func unwindToController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ExpenseTableViewController
        
        if let expense = sourceViewController.expense {
            appData.addExpense(expense)
            AppData.saveAppData(appData)
        }
    }
    
    // MARK: - Initialization of local variables
    var appData: AppData!
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNotificationsObserver()
        self.setupNavigationBar()
        self.setupSwipeRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        // If the app is opened before.
        if let loadedData = AppData.loadAppData() {
            appData = loadedData
        // If the app is never opened before.
        } else {
            let newData = AppData()
            AppData.saveAppData(newData)
            appData = newData
        }
        // Sets up the view of the controller.
        setupNavigationBar()
        updateMoneyLabels()
        setUpCircleLayers()
        updatePercentageAnimations()
    }
    
    // MARK: - objc functions
    /// Function which continues the pulsating animation when the app is first
    ///closed and then opened.
    @objc func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    /// Changes the tab bar controller when the user swipes the screen.
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            self.tabBarController?.selectedIndex += 1
        }
    }
    
    /// Checks if the user closed the app.
    private func setupNotificationsObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification , object: nil)
    }
    
    /// Set's the style of the navigation bar to the designed style.
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.light_pink
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor: UIColor.white]
        tabBarController?.tabBar.tintColor = UIColor.light_pink
    }
    
    /// Let's the user swipe between tab bar controllers.
    private func setupSwipeRecognizer() {
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    /// Creates a circle using the given stroke- and fillcolor.
    private func createLoadCircle(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100,
                                        startAngle: 0, endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.position = view.center
        return layer
    }
    
    /// Creates the full loading circle.
    private func setUpCircleLayers() {
        // Creates pulsating layer.
        pulsatingLayer = createLoadCircle(strokeColor: .clear, fillColor: UIColor.dark_pink)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        // Creates track layer.
        let trackLayer = createLoadCircle(strokeColor: UIColor.lightGray, fillColor: .white)
        view.layer.addSublayer(trackLayer)
        
        // Creates circle layer.
        shapeLayer = createLoadCircle(strokeColor: UIColor.light_pink,
                                      fillColor: .clear)
        shapeLayer.transform =
            CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    /// Manages the percentage label.
    private func updatePercentageAnimations() {
        view.addSubview(countingLabel)
        var percentage: Float = (appData.totalExpense() / appData.maxAmount)
        // Label should not increase more than 100%.
        if percentage > 1 {
            percentage = 1
        }
        countingLabel.count(from: 0, to: percentage * 100)
        
        // Animation of the circle layer.
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = CGFloat(percentage)
        basicAnimation.duration = 3
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "basic")
    }
    
    /// Configurations for the animations of the pullsating layer.
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.2
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    /// Updates the labels in the view.
    private func updateMoneyLabels() {
        updateMoneyLeftLabel()
        updateMaxAmountLabel()
        updateMoneyToSpendLabel()
        updateMoneySpendedLabel()
    }
    
    /// Updates the moneyLeftLabel.
    private func updateMoneyLeftLabel() {
        if appData.totalExpense() >= appData.maxAmount {
            moneyLabel.textColor = UIColor.red
            moneyToSpendLabel.textColor = UIColor.red
        } else {
            moneyLabel.textColor = UIColor.black
        }
    }
    
    /// Updates the maxAmountLabel.
    private func updateMaxAmountLabel() {
        let maxAmount = appData.maxAmount
        if floor(maxAmount) == maxAmount {
            maxAmountLabel.text = "Totaal: € \(Int(maxAmount))"
        } else {
            maxAmountLabel.text = "Totaal: € \(maxAmount)"
        }
    }
    
    /// Updates the moneyToSpendLabel.
    private func updateMoneyToSpendLabel() {
        toSpendLabel.text = "Nog te besteden:"
        let moneyLeft = appData.maxAmount - appData.totalExpense()
        if floor(moneyLeft) == moneyLeft {
            moneyLabel.text = "€ \(Int(moneyLeft))"
            moneyToSpendLabel.text = "€ \(Int(moneyLeft))"
        } else {
            moneyLabel.text = "€ \(moneyLeft)"
            moneyToSpendLabel.text = "€ \(moneyLeft)"
        }
    }
    
    /// Updates the moneySpendedLabel.
    private func updateMoneySpendedLabel() {
        spendedLabel.text = "Uitgegeven:"
        let moneySpended = appData.totalExpense()
        if floor(moneySpended) == moneySpended {
            moneySpendedLabel.text = "€ \(Int(moneySpended))"
        } else {
            moneySpendedLabel.text = "€ \(moneySpended)"
        }
    }
    
    /// Checks if a new expense can be added.
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        // If there are no categories saved, it should not be able to add a new
        // expense.
        if appData.categories.count == 0 {
            // Shows an alert in the screen.
            let alert = UIAlertController(title: "Fout!",
                                          message: "Voeg een categorie toe.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}
