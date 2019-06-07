//
//  AwayTableViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class AwayTableViewController: UITableViewController {
    
    var expenses = [Expense]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        if let appData = AppData.loadAppData() {
            expenses = appData.expenses
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This line set an intelligent edit button that just works.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCellIdentifier", for: indexPath) as! ExpenseCell
        
        let expense = expenses[indexPath.row]
        
        if floor(expense.amount) == expense.amount {
            cell.expenseLabel.text = "€ " + String(Int(expense.amount))
        } else {
            cell.expenseLabel.text = "€ " + String(expense.amount)
        }
        
        cell.categoryLabel.text = expense.category
        cell.dateLabel.text = Expense.dueDateFormatter.string(from: expense.dueDate)
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if var appData = AppData.loadAppData() {
                appData.expenses = expenses
                AppData.saveAppData(appData)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @IBAction func unwindToController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ExpenseTableViewController
        
        if let expense = sourceViewController.expense {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                expenses[selectedIndexPath.row] = expense
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: expenses.count, section: 0)
                expenses.append(expense)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        if var appData = AppData.loadAppData() {
            appData.expenses = expenses
            AppData.saveAppData(appData)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let expenseViewController = segue.destination as! ExpenseTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedExpense = expenses[indexPath.row]
            expenseViewController.expense = selectedExpense
        }
    }
}
