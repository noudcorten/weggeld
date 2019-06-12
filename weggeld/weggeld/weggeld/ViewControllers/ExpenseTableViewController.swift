//
//  ExpenseTableViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class ExpenseTableViewController: UITableViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var notesUIView: UIView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var expense: Expense?
    var appData: AppData?
    var isExtraInfoHidden: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        self.hideKeyboardWhenTappedAround()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        appData = AppData.loadAppData()
        
        if let expense = expense {
            setExpenseInfo(expense: expense)
        } else {
            navigationItem.title = appData!.categories[0]
            dueDatePickerView.date = Date()
        }
        
        updateDueDateLabel(with: dueDatePickerView.date)
        updateSaveButtonState()
    }
    
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch (indexPath.section, indexPath.row) {
//        case (2,0):
//            isExtraInfoHidden = !isExtraInfoHidden
//
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        default:
//            break
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let largeBoxHeight = CGFloat(200)
//        let smallBoxHeight = CGFloat(44)
//
//        switch (indexPath.section, indexPath.row) {
//        case (0,1):
//            return largeBoxHeight
//        case (1,0):
//            return largeBoxHeight
//        case (2,0):
//            print(isExtraInfoHidden)
//            return isExtraInfoHidden ? smallBoxHeight : largeBoxHeight
//        default:
//            return smallBoxHeight
//        }
//    }

    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        updateDueDateLabel(with: dueDatePickerView.date)
    }
    
    private func setExpenseInfo(expense: Expense) {
        navigationItem.title = expense.category
        if floor(expense.amount) == expense.amount {
            amountTextField.text = String(Int(expense.amount))
        } else {
            amountTextField.text = String(expense.amount)
        }
        dueDatePickerView.maximumDate = Date()
        dueDatePickerView.date = expense.dueDate
        pickerView.selectRow(appData!.categories.firstIndex(of: expense.category)!, inComponent: 0, animated: true)
        notesTextView.text = expense.notes
    }
    
    /// Disable the save button if there is no title.
    private func updateSaveButtonState() {
        let text = amountTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    /// Update the due date label to match the date from the date picker.
    /// - parameter date: The actual date from the data picker.
    private func updateDueDateLabel(with date: Date) {
        dueDateLabel.text = Expense.dueDateFormatter.string(from: date)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var text = amountTextField.text!
        
        if text.contains(",") {
            text = text.replacingOccurrences(of: ",", with: ".")
            amountTextField.text = text
        }
        
        if identifier == "saveUnwind" {
            if let _ = Float(text) {
                let dotString = "."
                if text.contains(dotString) {
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
        
        let alert = UIAlertController(title: "Fout!", message: "Voer een juist getal in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        
        return false
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /// Prepares everything before the segue happens.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        
        let amount = abs(Float(amountTextField.text!)!)
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        let category = navigationItem.title!
        
        expense = Expense(amount: amount, dueDate: dueDate, notes: notes, category: category)
    }

}

extension ExpenseTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appData!.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        navigationItem.title = appData!.categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return appData!.categories[row]
    }
}
