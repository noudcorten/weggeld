//
//  StatisticsViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {

    @IBOutlet weak var pieChartAllCategories: PieChartView!
    
    var appData: AppData?
    var categoryPieChart = PieChartDataEntry(value: 0)
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        appData = AppData.loadAppData()
        
        pieChartAllCategories.chartDescription?.text = "Alle Categorieën"
//        for expense in appData!.expenses {
        
//        }
//        category_1 = appData!.expenses[0]
//        category_2 = appData!.expenses
    }

    private func updateChartData() {
        updateAllCategoriesChart()
    }
    
    private func updateAllCategoriesChart() {
        
    }
}
