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

    @IBOutlet weak var monthYearPicker: UISegmentedControl!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pieChartAllCategories: PieChartView!
    @IBOutlet weak var barChartAllCategories: BarChartView!
    @IBOutlet weak var barChartAllMonths: BarChartView!
    
    
    var appData: AppData?
    let maxEntryLength = 10
    var monthIsPicked = true
    var pickedMonth = String()
    var pickedYear = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        appData = AppData.loadAppData()
        
        pickedYear = Expense.getYear.string(from: Date())
        let monthNumber = Expense.getMonthNumber.string(from: Date())
        let monthString = appData!.months[Int(monthNumber)!-1]
        if let usedMonths = appData!.getUsedMonths(year: pickedYear) {
            if let indexInUsedMonth = usedMonths.firstIndex(of: monthString) {
                pickedMonth = String(indexInUsedMonth)
            }
        }
    
        loadUI()
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        monthIsPicked = !monthIsPicked
        if !(appData!.isEmpty) {
            self.pickedMonth = String(pickerView.selectedRow(inComponent: 0))
            self.pickedYear = Array(appData!.getDateDict().keys)[pickerView.selectedRow(inComponent: 1)]
        }
        loadUI()
    }
    
    func loadUI() {
        setupConfigurations()
        createAllCategoriesPieChart()
        createAllCategoriesBarChart()
        createAllMonthsBarChart()
    }
    
    func setupConfigurations() {
        if appData!.getUsedMonths(year: pickedYear)!.count > 0 {
            pickerView.selectRow(Int(pickedMonth)!, inComponent: 0, animated: true)
            pickerView.selectRow(Array(appData!.getDateDict().keys).firstIndex(of:pickedYear)!, inComponent: 1, animated: true)
        }
    }
    
    func createAllCategoriesPieChart() {
        pieChartAllCategories.chartDescription?.text = "in percentages (%)"
        var dataEntries = [PieChartDataEntry]()
        
        if !(appData!.isEmpty) {
            let monthString = appData!.getUsedMonths(year: pickedYear)![Int(pickedMonth)!]
            
            if monthIsPicked {
                if let categoryMonthMoneyDict = appData!.getCategoryMonthMoneyDict(year:pickedYear, month: monthString) {
                    dataEntries = getPieChartDataEntries(dict: categoryMonthMoneyDict)
                }
            } else {
                if let categoryYearMoneyDict = appData!.getCategoryYearMoneyDict(year: pickedYear) {
                    dataEntries = getPieChartDataEntries(dict: categoryYearMoneyDict)
                }
            }
        }
        
        updatePieChartData(chart: pieChartAllCategories, data: dataEntries, label: "")
    }
        
    func getPieChartDataEntries(dict: [String: Float]) -> [PieChartDataEntry] {
        var dataEntries = [PieChartDataEntry]()
        
        for (label, value) in dict {
            let categoryPieChart = PieChartDataEntry(value: Double(value), label: label)
            dataEntries.append(categoryPieChart)
        }
        
        return dataEntries
    }
    
    func updatePieChartData(chart: PieChartView, data: [PieChartDataEntry], label: String) {
        chart.drawEntryLabelsEnabled = false
        chart.usePercentValuesEnabled = true
        
        let chartDataSet = PieChartDataSet(values: data, label: label)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.colors = UIColor.chartColors()
        chart.data = chartData
    }
    
    func createAllCategoriesBarChart() {
        var dataEntries = [String: BarChartDataEntry]()
        
        if !(appData!.isEmpty) {
            let monthString = appData!.getUsedMonths(year: pickedYear)![Int(pickedMonth)!]
            if monthIsPicked {
                if let categoryMonthMoneyDict = appData!.getCategoryMonthMoneyDict(year: pickedYear, month: monthString) {
                    dataEntries = getBarChartDataEntries(dict: categoryMonthMoneyDict)
                }
            } else {
                if let categoryYearMoneyDict = appData!.getCategoryYearMoneyDict(year: pickedYear) {
                    dataEntries = getBarChartDataEntries(dict: categoryYearMoneyDict)
                }
            }
        }

        updateBarChartData(chart: barChartAllCategories, data: dataEntries, label: "")
    }

    func createAllMonthsBarChart() {
        var dataEntries = [String: BarChartDataEntry]()
        
        if !(appData!.isEmpty) {
            if let yearMoneyDict = appData!.getYearMoneyDict(year: pickedYear) {
                dataEntries = getBarChartDataEntries(dict: yearMoneyDict)
            }
        }
        
        updateBarChartData(chart: barChartAllMonths, data: dataEntries, label: "")
    }

    func getBarChartDataEntries(dict: [String: Float]) -> [String: BarChartDataEntry] {
        var dataEntries = [String: BarChartDataEntry]()
        var count: Double = 0

        for (label, value) in dict {
            let categoryBarChart = BarChartDataEntry(x: count, y: Double(value))
            categoryBarChart.yValues = [Double(value), Double(0)]
            count += 1
            dataEntries[label] = categoryBarChart
        }

        return dataEntries
    }

    func updateBarChartData(chart: BarChartView, data: [String: BarChartDataEntry], label: String) {
        setupBarChartConfigurations(chart: chart)
        
        if !(appData!.isEmpty) {
            let chartData = BarChartData()
            let colors = UIColor.chartColors()
            
            for (offset: index, element: (key: label, value: entry)) in data.enumerated() {
                let chartDataSet = BarChartDataSet(values: [entry], label: label)
                chartDataSet.colors = [colors[index]]
                chartDataSet.valueColors = [UIColor.black]
                chartData.addDataSet(chartDataSet)
            }
            chart.data = chartData
            chart.animate(yAxisDuration: 0.5, easingOption: .easeInExpo)
            
        } else {
            let chartDataSet = BarChartDataSet(values: [BarChartDataEntry](), label: "")
            let chartData = BarChartData(dataSet: chartDataSet)
            chart.data = chartData
        }
    }
    
    func setupBarChartConfigurations(chart: BarChartView) {
        chart.drawValueAboveBarEnabled = true
        chart.legend.enabled = true
        chart.xAxis.labelCount = 1
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values:[""])
        chart.rightAxis.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.axisMinimum = 0
        chart.fitBars = true
    }
}

extension StatisticsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return appData!.getUsedMonths(year: pickedYear)!.count
        case 1:
            return appData!.getDateDict().keys.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return appData!.getUsedMonths(year: pickedYear)![row]
        case 1:
            return Array(appData!.getDateDict().keys)[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !(appData!.isEmpty) {
            self.pickedMonth = String(pickerView.selectedRow(inComponent: 0))
            self.pickedYear = Array(appData!.getDateDict().keys)[pickerView.selectedRow(inComponent: 1)]
        }
        
        loadUI()
    }
}

