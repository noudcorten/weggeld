//
//  AwayTableViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class AwayTableViewController: UITableViewController {
    
    var appData: AppData?
    var expenses = [Expense]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        appData = AppData.loadAppData()
        expenses = appData!.expenses
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numOfSections = appData!.getAllExpensesList()!.count
        if numOfSections > 0 {
            return numOfSections
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allExpensesList = appData!.getAllExpensesList()!
    
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
        let allExpensesList = appData!.getAllExpensesList()!
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
        let pickedColor = appData!.category_dict[expense.category]!
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
            let allExpensesList = appData!.getAllExpensesList()!
            let expensesList = allExpensesList[indexPath.section]
            let expense = expensesList[indexPath.row]
            
            appData!.removeExpense(expense)
            AppData.saveAppData(appData!)
            
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
        let view = UIView()
        
        let numOfSections = appData!.getAllExpensesList()!.count
        if numOfSections > 0 {
            view.backgroundColor = UIColor.outlineStrokeColor
            
            let label = UILabel()
            label.textColor = UIColor.white
            label.frame = CGRect(x: 10, y: 3, width: 200, height: 20)
            
            let allUsedMonths = appData!.getAllUsedMonthsString()
            label.text = allUsedMonths[section]
            
            view.addSubview(label)
        }
        return view
    }
    
    @IBAction func unwindToController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ExpenseTableViewController
        
        if let expense = sourceViewController.expense {
            if let _ = tableView.indexPathForSelectedRow {
                appData!.replaceExpense(expense)
            } else {
                 appData!.addExpense(expense)
            }
            AppData.saveAppData(appData!)
            tableView.reloadData()
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let expenseViewController = segue.destination as! ExpenseTableViewController
            let allExpensesList = appData!.getAllExpensesList()!
            
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedExpense = allExpensesList[indexPath.section][indexPath.row]
            expenseViewController.expense = selectedExpense
        }
    }
}
