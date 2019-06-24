//
//  AwayTableViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class AwayTableViewController: UITableViewController {
    
    @IBAction func unwindToController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ExpenseTableViewController
        
        if let expense = sourceViewController.expense {
            if let _ = tableView.indexPathForSelectedRow {
                if let prevExpense = sourceViewController.prevExpense {
                    appData.replaceExpense(prevExpense, expense)
                }
            } else {
                appData.addExpense(expense)
            }
            AppData.saveAppData(appData)
            tableView.reloadData()
        }
    }
    
    var appData: AppData!
    var expenses = [Expense]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        appData = AppData.loadAppData()
        expenses = appData.expenses
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwipeRecognizer()
        self.setupNavigationBar()
    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            self.tabBarController?.selectedIndex += 1
        } else if gesture.direction == .right {
            self.tabBarController?.selectedIndex -= 1
        }
    }
    
    private func setupSwipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.gray
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem!.title = "Wijzig"
    }
    
    private func getLabel(section: Int, x: Int, y: Int, width: Int, height: Int, text: String?) -> UILabel {
        let width = 200
        let height = 20
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.frame = CGRect(x: x, y: y, width: width, height: height)
        
        if let text = text {
            label.text = text
        } else {
            let allUsedMonths = appData.getAllUsedMonthsString()
            label.text = allUsedMonths[section]!
        }
        
        return label
        
    }
    
    override func setEditing (_ editing:Bool, animated:Bool) {
        super.setEditing(editing,animated:animated)
        
        if self.isEditing {
            self.editButtonItem.title = "Klaar"
        } else {
            self.editButtonItem.title = "Wijzig"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numOfSections = appData.getAllExpensesList()!.count
        if numOfSections > 0 {
            return numOfSections
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allExpensesList = appData.getAllExpensesList()!
    
        let numOfSections = allExpensesList.count
        if numOfSections > 0 {
            let numOfRows = allExpensesList[section].count
            if numOfRows > 0 {
                return numOfRows
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCellIdentifier", for: indexPath) as! ExpenseCell
        let allExpensesList = appData.getAllExpensesList()!
        let expenseList = allExpensesList[indexPath.section]
        let expense = expenseList[indexPath.row]
        
        if floor(expense.amount) == expense.amount {
            cell.expenseLabel.text = "€ " + String(Int(expense.amount))
        } else {
            cell.expenseLabel.text = "€ " + String(expense.amount)
        }
        
        cell.categoryLabel.text = expense.category
        cell.dateLabel.text = Expense.dueDateFormatter.string(from: expense.dueDate)
        
        let colors = UIColor.categoryColors()
        let pickedColor = appData.category_dict[expense.category]!
        cell.colorView.backgroundColor = colors[pickedColor]
        
        let radius = cell.colorView.frame.height / 2
        cell.colorView.layer.cornerRadius = radius
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let allExpensesList = appData.getAllExpensesList()!
            let expensesList = allExpensesList[indexPath.section]
            let expense = expensesList[indexPath.row]
            
            appData.removeExpense(expense)
            AppData.saveAppData(appData)
            
            if expensesList.count > 1 {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let window_width = Int(self.view.frame.size.width)
        let currentMonth_width = 110
        let month_width = 200
        let currentMonth_x_offset = window_width - currentMonth_width
        let month_x_offset = 10
        let y_offset = 3
        let height = 20
        
        let view = UIView()
        let allExpensesList = appData.getAllExpensesList()!
        
        if allExpensesList.count > 0 {
            let monthLabel = getLabel(section: section, x: month_x_offset, y: y_offset, width: month_width, height: height, text: nil)
            view.addSubview(monthLabel)
            
            if Expense.getMonthYear.string(from: allExpensesList[section].first!.dueDate) == Expense.getMonthYear.string(from: Date()) {
                view.backgroundColor = UIColor.dark_pink
                
                let currentMonthLabel = getLabel(section: section, x: currentMonth_x_offset, y: y_offset, width: currentMonth_width, height: height, text: "Deze maand")
                monthLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                currentMonthLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                view.addSubview(currentMonthLabel)
            } else {
                view.backgroundColor = UIColor.light_pink
            }
        }
        return view
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if appData.categories.count == 0 {
            let alert = UIAlertController(title: "Fout!", message: "Voeg een categorie toe.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let expenseViewController = segue.destination as! ExpenseTableViewController
            let allExpensesList = appData.getAllExpensesList()!
            
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedExpense = allExpensesList[indexPath.section][indexPath.row]
            expenseViewController.expense = selectedExpense
        }
    }
}
