//
//  AwayTableViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* Class which controls all the expenses done by the user. It shows which
expenses are done, in which month the expenses are done, etc. This screen also
allows the user to edit his/her expenses. */
class AwayTableViewController: UITableViewController {
    
    // MARK: - Initialization of the IBOutlets.
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
    
    // MARK: - Initialization of local variables
    var appData: AppData!
    var expenses = [Expense]()
    
    // MARK: - View controller lifecycle methods
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
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    /// Set's the style of the navigation bar to the designed style.
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.gray
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes =
            [.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem!.title = "Wijzig"
    }
    
    /// Returns a UILabel width the given properties.
    private func getLabel(section: Int, x: Int, y: Int, width: Int, height: Int,
                          text: String?) -> UILabel {
        let width = 200
        let height = 20
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // If text has a value, the label is used for 'This Month'-label.
        if let text = text {
            label.text = text
        // If text has no value, the label is used for month indexing.
        } else {
            let allUsedMonths = appData.getAllUsedMonthsString()
            label.text = allUsedMonths[section]
        }
        return label
    }
    
    /// If the table view is in editing mode, the label is changed to it's
    /// corresponding title.
    override func setEditing (_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if self.isEditing {
            self.editButtonItem.title = "Klaar"
        } else {
            self.editButtonItem.title = "Wijzig"
        }
    }
    
    // MARK: - Configurations of the TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numOfSections = appData.getAllExpensesList()!.count
        if numOfSections > 0 {
            return numOfSections
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) ->
                            UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ExpenseCellIdentifier",
            for: indexPath) as! ExpenseCell
        let allExpensesList = appData.getAllExpensesList()!
        let expense = allExpensesList[indexPath.section][indexPath.row]
        
        // Sets the text of the expenseLabel to an Int when that's possible.
        if floor(expense.amount) == expense.amount {
            cell.expenseLabel.text = "€ \(Int(expense.amount))"
        } else {
            let expenseString = String(format: "%0.2f", expense.amount)
            cell.expenseLabel.text = "€ " + expenseString
        }
        
        // Updates the category- and datelabels.
        cell.categoryLabel.text = expense.category
        cell.dateLabel.text = DateFormatter.dueDateFormatter.string(
            from: expense.dueDate)
                                
        // Sets the colorView to the color corresponding to the category.
        let colors = UIColor.categoryColors()
        let pickedColor = appData.category_dict[expense.category]!
        cell.colorView.backgroundColor = colors[pickedColor]
                                
        // Changes the UIView to a circle.
        let radius = cell.colorView.frame.height / 2
        cell.colorView.layer.cornerRadius = radius
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        // Defines standard configurations.
        let window_width = Int(self.view.frame.size.width)
        let currentMonth_width = 110
        let month_width = 200
        let currentMonth_x_offset = window_width - currentMonth_width
        let month_x_offset = 10
        let y_offset = 3
        let height = 20
    
        // Creates the HeaderView.
        let view = UIView()
        let allExpensesList = appData.getAllExpensesList()!
        
        if allExpensesList.count > 0 {
            // Creates monthLabel (by setting 'text' = nil).
            let monthLabel = getLabel(section: section, x: month_x_offset,
                                      y: y_offset, width: month_width,
                                      height: height, text: nil)
            view.addSubview(monthLabel)
            
            // If the current list of expenses are done in the current month,
            // it changes the header of these expenses to a 'This Month'-header
            // for more readability.
            if DateFormatter.getMonthYear.string(from: allExpensesList[section].first!.dueDate) == DateFormatter.getMonthYear.string(from: Date()) {
                // Creates the 'This Month'-label.
                let currentMonthLabel = getLabel(section: section, x: currentMonth_x_offset, y: y_offset,
                                                 width: currentMonth_width,
                                                 height: height,
                                                 text: "Deze maand")
                monthLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                currentMonthLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                view.backgroundColor = UIColor.dark_pink
                view.addSubview(currentMonthLabel)
            } else {
                view.backgroundColor = UIColor.light_pink
            }
        }
        return view
    }
    
    /// Checks if a new expense can be added.
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        // If there are no categories saved, it should not be able to add a new
        // expense.
        if appData.categories.count == 0 {
            let alert = UIAlertController(title: "Fout!",
                                          message: "Voeg een categorie toe.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// If an expense in the TableView is selected, it opens the
        /// 'ExpenseTableView' with the details of the selected expense.
        if segue.identifier == "showDetails" {
            let expenseViewController = segue.destination as!
                ExpenseTableViewController
            let allExpensesList = appData.getAllExpensesList()!
            let indexPath = tableView.indexPathForSelectedRow!
            let expense = allExpensesList[indexPath.section][indexPath.row]
            expenseViewController.expense = expense
        }
    }
}
