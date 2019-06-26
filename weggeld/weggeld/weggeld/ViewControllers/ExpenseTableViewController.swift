//
//  ExpenseTableViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* Class that controls the view which represents all the information of an
expense (new or edited). In this view all the information of an expense can be
modified (amount, category, date and extra info). */
class ExpenseTableViewController: UITableViewController {
    
    // MARK: - Initialization of the IBOutlets.
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - Initialization of local variables
    var amountTextField: UITextField?
    var dueDateLabel: UILabel?
    var dueDatePickerView: UIDatePicker?
    var todayButton: UIButton?
    var categoryLabel: UILabel?
    var colorView: UIView?
    var pickerView: UIPickerView?
    var notesTextField: UITextField?
    
    var expense: Expense?
    var prevExpense: Expense?
    var appData: AppData!
    
    // MARK: - Initialization of local constants
    let maxAmount: Float = 1000000
    
    // MARK: - View controller lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        appData = AppData.loadAppData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setupNavigationBar()
    }
    
    // MARK: - objc functions
    /// Calls checkAmountTextField() when a change is made to amountTextField.
    @objc func textEditingChanged(_ sender: UITextField) {
        checkAmountTextField()
    }
    
    /// If the user starts editing the notesTextField the view is shifted so the
    /// keyboard doesn't fall over the textfield.
    @objc func beginEditing(_ sender: UITextField) {
        let frame_width = Int(self.view.frame.size.width)
        tableView.contentOffset = CGPoint(x: 0, y: frame_width/2)
    }
    
    /// If the user is done with editing the notesTextField, the view is
    /// shifted back to the begin position.
    @objc func endEditing(_ sender: UITextField) {
        tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    /// If the user presses 'Return' the view is shifted back to the begin
    /// position.
    @objc func returnPressed(_ sender: UITextField) {
        self.view.endEditing(true)
        tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    /// If the date is changed, it updates the label representing this date.
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(with: dueDatePickerView!.date)
    }
    
    /// When todayButton is clicked it set's the datePicker back to the current
    /// date.
    @objc func todayButtonClicked(_ sender: UIButton) {
        updateDueDateLabel(with: Date())
        dueDatePickerView!.date = Date()
    }
    
     /// Set's the style of the navigation bar to the designed style.
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.gray
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor: UIColor.white]
        
        // If the user is editing an expense.
        if let _ = expense {
            self.title = "Uitgave Wijzigen"
        }
    }
    
    /// Disable the save button if there is no title.
    private func checkAmountTextField() {
        let text = amountTextField!.text ?? ""
        if let amount = Float(text) {
            checkForMaxAmount(amount)
        }
        saveButton.isEnabled = !text.isEmpty
    }
    
    /// Prevents the user from inserting a number that's bigger than the
    /// defined maxAmount.
    private func checkForMaxAmount(_ amount: Float) {
        if amount > maxAmount {
            // Sends alert.
            let alert = UIAlertController(
                title: "Fout!",
                message: "Getal mag niet groter zijn dan 1.000.000",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            // Removes the last inserted number, which triggerd the alert.
            var text = amountTextField!.text!
            text.remove(at: text.index(before: text.endIndex))
            amountTextField!.text = text
        }
    }

    /// Updates the dueDateLabel with the given date to match the date from the
    /// datePicker.
    private func updateDueDateLabel(with date: Date) {
        dueDateLabel!.text = DateFormatter.dueDateFormatter.string(from: date)
    }
    
    // MARK: - Configurations of the TabeView.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(40)
        let largeCellHeight = CGFloat(200)
        
        switch indexPath.section {
        case 1...2:
            return largeCellHeight
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) ->
                            UITableViewCell {
        switch indexPath.section {
        // InputCell
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "InputCell", for: indexPath) as!
                ExpenseInputCell

            // Sets the cell IBOutlets to local variables
            cell.amountTextField.delegate = self as? UITextFieldDelegate
            amountTextField = cell.amountTextField
            amountTextField!.addTarget(self, action: #selector(self.textEditingChanged(_:)), for: UIControl.Event.editingChanged)
            
            // If the user is editing an expense.
            if let expense = expense {
                // If the expense is writeable as an int.
                if floor(expense.amount) == expense.amount {
                    amountTextField!.text = "\(Int(expense.amount))"
                } else {
                    amountTextField!.text = "\(expense.amount)"
                }
            }
            checkAmountTextField()
            return cell
            
        // CategoryCell
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CategoryCell", for: indexPath) as!
                ExpenseCategoryCell
            // Sets the cell IBOutlets to local variables
            pickerView = cell.pickerView
            categoryLabel = cell.categoryLabel
            colorView = cell.colorView
            
            // Fetches usefull data.
            let colors = UIColor.categoryColors()
            let category_dict = appData.category_dict
            var category: String
            
            // If the user is editing an expense.
            if let expense = expense {
                category = expense.category
            } else {
                category = appData.categories[0]
            }
            
            // Set properties of IBOutlets.
            categoryLabel!.text = category
            let index = category_dict[category]
            colorView!.backgroundColor = colors[index!]
            pickerView!.selectRow(appData.categories.firstIndex(of: category)!, inComponent: 0, animated: true)
            return cell
            
        // DateCell
        case 2:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "DateCell", for: indexPath) as! ExpenseDateCell
            // Sets the cell IBOutlets to local variables.
            dueDateLabel = cell.dueDateLabel
            dueDatePickerView = cell.dueDatePickerView
            todayButton = cell.todayButton
            
            // Add event for changing of value.
            dueDatePickerView!.addTarget(self, action: #selector(
                self.datePickerChanged), for: UIControl.Event.valueChanged)
            // Add event for clicking the button.
            todayButton!.addTarget(self, action: #selector(
                self.todayButtonClicked), for: UIControl.Event.touchUpInside)
            
            // If the user is editing an expense.
            if let expense = expense {
                dueDatePickerView!.date = expense.dueDate
            } else {
                dueDatePickerView!.date = Date()
            }
            updateDueDateLabel(with: dueDatePickerView!.date)
            return cell
            
        // NotesCell
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "InfoCell", for: indexPath) as! ExpenseInfoCell
            // Sets the cell IBOutlets to local variables.
            cell.notesTextField.delegate = self as? UITextFieldDelegate
            notesTextField = cell.notesTextField
            
            // Add action for start editing.
            notesTextField!.addTarget(self, action: #selector(
                self.beginEditing(_:)), for: .editingDidBegin)
            // Add action for end editing.
            notesTextField!.addTarget(self, action: #selector(
                self.endEditing(_:)), for: .editingDidEnd)
            // Add action for pressing 'Return'.
            notesTextField!.addTarget(self, action: #selector(
                self.returnPressed(_:)), for: .primaryActionTriggered)
            
            // If the user is editing an expense.
            if let expense = expense {
                notesTextField!.text = expense.notes
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        // Creates UIView.
        let view = UIView()
        view.backgroundColor = UIColor.light_pink

        // Creates UILabel.
        let label = UILabel()
        label.textColor = UIColor.white
        label.frame = CGRect(x: 10, y: 3, width: 200, height: 20)
        
        // Sets the text of the corresponding header.
        switch section {
        case 0:
            label.text = "UITGAVE"
        case 1:
            label.text = "CATEGORIE"
        case 2:
            label.text = "DATUM"
        default:
            label.text = "EXTRA INFO"
        }
        
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        var text = amountTextField!.text!
        
        // Replaces a ',' with a '.' because floats are represented with '.',
        // while text input is only possible with a ','
        if text.contains(",") {
            text = text.replacingOccurrences(of: ",", with: ".")
            amountTextField!.text = text
        }
        
        // Checks if the entered number is correct.
        if identifier == "saveUnwind" {
            if let _ = Float(text) {
                let dotString = "."
                if text.contains(dotString) {
                    // Checks if there are 2 digits after the comma.
                    if text.components(separatedBy: dotString)[1].count <= 2 {
                        return true
                    }
                } else {
                    return true
                }
            }
        } else {
            return true
        }
        
        // Sends alert.
        let alert = UIAlertController(title: "Fout!",
                                      message: "Voer een juist getal in.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        
        return false
    }
    
    
    /// Prepares everything before the segue happens.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        
        let amount = abs(Float(amountTextField!.text!)!)
        let dueDate = dueDatePickerView!.date
        let notes = notesTextField!.text
        let category = categoryLabel!.text!
        
        prevExpense = expense
        expense = Expense(dueDate: dueDate, amount: amount, category: category,
                          notes: notes)
    }

}
