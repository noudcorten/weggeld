//
//  MoneyViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class MoneyViewController: UIViewController {

    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var appData: AppData?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        if let appData = AppData.loadAppData() {
            AppData.saveAppData(appData)
        } else {
            let appData = AppData(expenses: [], maxAmount: 100.0)
            AppData.saveAppData(appData)
            
        }
        
        appData = AppData.loadAppData()
        
        updateMoneyLabel()
        updateProgressBar()
    }
    
    func updateMoneyLabel() {
        if appData!.totalExpense() > appData!.maxAmount {
            moneyLabel.textColor = UIColor.red
        } else {
            moneyLabel.textColor = UIColor.black
        }
        let moneyLeft = appData!.maxAmount - appData!.totalExpense()
        moneyLabel.text = "€ " + String(moneyLeft)
    }
    
    func updateProgressBar() {
        let progress = appData!.totalExpense() / appData!.maxAmount
        if progress > 1 {
            progressBar.setProgress(progress, animated: false)
        } else {
            progressBar.setProgress(progress, animated: true)
        }
        
    }


    
    @IBAction func unwindToController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ExpenseTableViewController
        
        if let expense = sourceViewController.expense {
            appData!.expenses.append(expense)
            AppData.saveAppData(appData!)
        }
    }
        
        
}
