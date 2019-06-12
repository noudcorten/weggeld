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
    let maxEntryLength = 10
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        appData = AppData.loadAppData()
        
        createAllCategoriesPieChart()
    }
    
    func createAllCategoriesPieChart() {
        pieChartAllCategories.chartDescription?.text = "Alle Categorieën (%)"
        var dataEntries = [PieChartDataEntry]()
        let moneyByCategory = appData!.getMoneyByCategory()
        
        for category in appData!.categories {
            if let value = moneyByCategory[category] {
                let categoryPieChart = PieChartDataEntry()
                categoryPieChart.value = Double((value / appData!.totalExpense()) * 100)
                categoryPieChart.label = category
                dataEntries.append(categoryPieChart)
            }
        }
        
        let sortedEntries = getSortedEntryList(data: dataEntries)
        updatePieChartData(data: sortedEntries, label: "")
    }

    func getSortedEntryList(data: [PieChartDataEntry]) -> [PieChartDataEntry] {
        var sortedDataEntries = [PieChartDataEntry]()
        sortedDataEntries = data.sorted(by: {$0.value > $1.value})
        
        var chartEntries = [PieChartDataEntry]()
        var length: Int
        if sortedDataEntries.count < maxEntryLength {
            length = sortedDataEntries.count
        } else {
            length = maxEntryLength
        }
        for i in 0...length-1 {
            chartEntries.append(sortedDataEntries[i])
        }
        return chartEntries
    }
    
    func updatePieChartData(data: [PieChartDataEntry], label: String) {
        let chartDataSet = PieChartDataSet(values: data, label: label)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.colors = UIColor.pieChartColors()
        chartDataSet.entryLabelColor = UIColor.black
        chartDataSet.valueColors = [UIColor.black]
        
        pieChartAllCategories.data = chartData
    }
}
