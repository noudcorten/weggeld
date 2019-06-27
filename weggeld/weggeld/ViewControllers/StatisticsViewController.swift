//
//  StatisticsViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit
import Charts

/* Class which shows graphs based on the user's expenses. It uses the plug-in
 'Charts' to create three graphs: 1. PieChart based on */
class StatisticsViewController: UIViewController {

    // MARK: - Initialization of the IBOutlets.
    @IBOutlet weak var monthYearPicker: UISegmentedControl!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pieChartAllCategories: PieChartView!
    @IBOutlet weak var barChartAllCategories: BarChartView!
    @IBOutlet weak var barChartAllMonths: BarChartView!
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        monthIsPicked = !monthIsPicked
        if !(appData.isEmpty) {
            self.pickedMonth = String(pickerView.selectedRow(inComponent: 0))
            self.pickedYear = Array(appData.getDateDict().keys)[pickerView.selectedRow(inComponent: 1)]
        }
        loadUI()
    }
    
    // MARK: - Initialization of local variables
    var appData: AppData!
    var monthIsPicked = true
    var pickedMonth = String()
    var pickedYear = String()

    // MARK: - View controller lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        appData = AppData.loadAppData()
        
        setupMonthAndYear()
        loadUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwipeRecognizer()
        self.setupNavigationBar()
    }
    
    // MARK: - objc functions
    /// Changes the tab bar controller when the user swipes the screen.
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            self.tabBarController?.selectedIndex += 1
        } else if gesture.direction == .right {
            self.tabBarController?.selectedIndex -= 1
        }
    }
    
    /// Let's the user swipe between tab bar controllers.
    private func setupSwipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    /// Set's the style of the navigation bar to the designed style.
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.gray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    /// Selects the month and year for which the charts need to be generated.
    private func setupMonthAndYear() {
        monthYearPicker.tintColor = UIColor.light_pink
        pickedYear = DateFormatter.getYear.string(from: Date())
        
        // If there are expenses made in the current year.
        if let usedMonths = appData.getUsedMonths(year: pickedYear) {
            let monthNumber = DateFormatter.getMonthNumber.string(from: Date())
            let monthString = appData.months[Int(monthNumber)!-1]
            // If there are expenses made in the current month.
            if let indexInUsedMonths = usedMonths.firstIndex(of: monthString) {
                pickedMonth = String(indexInUsedMonths)
            // If there are no expenses made in the current month
            } else {
                // Get the first month of the current year which has expenses.
                let usedMonth = usedMonths.first!
                if let indexInUsedMonths = usedMonths.firstIndex(of: usedMonth) {
                    pickedMonth = String(indexInUsedMonths)
                }
            }
        // If there are no expenses made in the current year.
        } else {
            // Get the first year which has expenses
            if let usedYears = appData.getUsedYears() {
                pickedYear = usedYears.first!
                if let usedMonths = appData.getUsedMonths(year: pickedYear) {
                    // Get first month of selected year that has expenses.
                    let usedMonth = usedMonths.first!
                    if let indexInUsedMonths = usedMonths.firstIndex(of: usedMonth) {
                        pickedMonth = String(indexInUsedMonths)
                    }
                }
            }
        }
    }
    
    /// Updates the UI bases on selected data.
    private func loadUI() {
        setupConfigurations()
        createAllCategoriesPieChart()
        createAllCategoriesBarChart()
        createAllMonthsBarChart()
    }
    
    /// Selects the selected month and year in the pickerView.
    private func setupConfigurations() {
        if let usedMonths = appData.getUsedMonths(year: pickedYear) {
            if usedMonths.count > 0 {
                pickerView.selectRow(Int(pickedMonth)!, inComponent: 0, animated: true)
                pickerView.selectRow(Array(appData.getDateDict().keys).firstIndex(of:pickedYear)!, inComponent: 1, animated: true)
            }
        }
    }
    
    /// Creates the allCategoriesPieChart.
    private func createAllCategoriesPieChart() {
        pieChartAllCategories.chartDescription?.text = "in percentages (%)"
        var dataEntries = [PieChartDataEntry]()
        // Only fills dataEntry if there are expenses made.
        if !(appData.isEmpty) {
            let monthString = appData.getUsedMonths(year: pickedYear)![Int(pickedMonth)!]
            if monthIsPicked {
                if let categoryMonthMoneyDict = appData.getCategoryMonthMoneyDict(year:pickedYear, month: monthString) {
                    dataEntries = getPieChartDataEntries(dict: categoryMonthMoneyDict)
                }
            } else {
                if let categoryYearMoneyDict = appData.getCategoryYearMoneyDict(year: pickedYear) {
                    dataEntries = getPieChartDataEntries(dict: categoryYearMoneyDict)
                }
            }
        }
        updatePieChartData(chart: pieChartAllCategories, data: dataEntries, label: "")
    }
    
    /// Get's the pieChartDateEntries used for the PieChart.
    private func getPieChartDataEntries(dict: [String: Float]) -> [PieChartDataEntry] {
        var dataEntries = [PieChartDataEntry]()
        for (label, value) in dict {
            let categoryPieChart = PieChartDataEntry(value: Double(value), label: label)
            dataEntries.append(categoryPieChart)
        }
        return dataEntries
    }
    
    /// Finds the correct colors for the created entries.
    private func getPieChartColors(_ data: [PieChartDataEntry]) -> [UIColor] {
        var colors = [UIColor]()
        let categoryColors = UIColor.categoryColors()
        let category_dict = appData.category_dict
        
        for entry in data {
            if let index = category_dict[entry.label!] {
                colors.append(categoryColors[index])
            }
        }
        return colors
    }
    
    /// Updates the PieChart with the created data.
    private func updatePieChartData(chart: PieChartView, data: [PieChartDataEntry], label: String) {
        chart.drawEntryLabelsEnabled = false
        chart.usePercentValuesEnabled = true
        
        let chartDataSet = PieChartDataSet(values: data, label: label)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.colors = getPieChartColors(data)
        chart.data = chartData
    }
    
    /// Creates the allCategoriesBarChart.
    private func createAllCategoriesBarChart() {
        var dataEntries = [String: BarChartDataEntry]()
        // Only fills dataEntry if there are expenses made.
        if !(appData.isEmpty) {
            let monthString = appData.getUsedMonths(year: pickedYear)![Int(pickedMonth)!]
            if monthIsPicked {
                if let categoryMonthMoneyDict = appData.getCategoryMonthMoneyDict(year: pickedYear, month: monthString) {
                    dataEntries = getBarChartDataEntries(dict: categoryMonthMoneyDict)
                }
            } else {
                if let categoryYearMoneyDict = appData.getCategoryYearMoneyDict(year: pickedYear) {
                    dataEntries = getBarChartDataEntries(dict: categoryYearMoneyDict)
                }
            }
        }
        updateBarChartData(chart: barChartAllCategories, data: dataEntries, label: "")
    }

    /// Creates the allCategoriesBarChart.
    private func createAllMonthsBarChart() {
        var dataEntries = [String: BarChartDataEntry]()
        // Only fills dataEntry if there are expenses made.
        if !(appData.isEmpty) {
            if let yearMoneyDict = appData.getYearMoneyDict(year: pickedYear) {
                dataEntries = getBarChartDataEntries(dict: yearMoneyDict)
            }
        }
        updateBarChartData(chart: barChartAllMonths, data: dataEntries, label: "")
    }

    /// Get's the pieChartDateEntries used for the given BarChart.
    private func getBarChartDataEntries(dict: [String: Float]) -> [String: BarChartDataEntry] {
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

     /// Updates the given BarChart with the created data.
    private func updateBarChartData(chart: BarChartView, data: [String: BarChartDataEntry], label: String) {
        setupBarChartConfigurations(chart: chart)
        // Only creates the BarChart if there are expenses made.
        if !(appData.isEmpty) {
            let chartData = BarChartData()
            var colors: [UIColor]
            for (offset: index, element: (key: label, value: entry)) in data.enumerated() {
                let chartDataSet = BarChartDataSet(values: [entry], label: label)
                // Selects right colors for the AllMonthsBarChart.
                if appData.months.contains(label) {
                    colors = ChartColorTemplates.joyful()
                    chartDataSet.colors = [colors[index]]
                // Selects right colors for the AllCategoriesBarChart.
                } else if appData.categories.contains(label) {
                    colors = UIColor.categoryColors()
                    let newIndex = appData.category_dict[label]!
                    chartDataSet.colors = [colors[newIndex]]
                }
                chartDataSet.valueColors = [UIColor.black]
                chartData.addDataSet(chartDataSet)
            }
            chart.data = chartData
            chart.animate(yAxisDuration: 0.5, easingOption: .easeInExpo)
        // Creates empty charts if there are no expenses made.
        } else {
            let chartDataSet = BarChartDataSet(values: [BarChartDataEntry](), label: "")
            let chartData = BarChartData(dataSet: chartDataSet)
            chart.data = chartData
        }
    }
    
    /// Updates the style of the given BarChart.
    private func setupBarChartConfigurations(chart: BarChartView) {
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

/// Extension for the Controller so that it can handle the pickerView used for
/// selecting the month and year.
extension StatisticsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - Configurations for the pickerView.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            // Returns the amount of months of the given year.
            if let usedMonths = appData.getUsedMonths(year: pickedYear) {
                return usedMonths.count
            }
            return 0
        case 1:
            // Returns the amount of years.
            if let usedYears = appData.getUsedYears() {
                return usedYears.count
            }
            return 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return appData.getUsedMonths(year: pickedYear)![row]
        case 1:
            return appData.getUsedYears()![row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !(appData.isEmpty) {
            switch component {
            case 0:
                self.pickedMonth = String(pickerView.selectedRow(inComponent: component))
                if monthIsPicked {
                    loadUI()
                }
            case 1:
                self.pickedYear = appData.getUsedYears()![pickerView.selectedRow(inComponent: component)]
                // Selects the first month if a new year is selected.
                self.pickedMonth = String(0)
                pickerView.reloadAllComponents()
                loadUI()
            default:
                return
            }
        }
    }
}

