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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var expense: Expense?
    var categories = ["Auto", "Levensmiddelen", "Wonen", "Onderwijs", "Gezondheid", "Kleding", "Vakantie", "Leningen", "Liefdadigheid", "Vermaak", "Sparen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        if let expense = expense {
            navigationItem.title = expense.category
            amountTextField.text = String(expense.amount)
            dueDatePickerView.date = expense.dueDate
            pickerView.selectRow(categories.firstIndex(of: expense.category)!, inComponent: 0, animated: true)
            notesTextView.text = expense.notes
        } else {
            navigationItem.title = categories[0]
            dueDatePickerView.date = Date()
        }
        
        dueDatePickerView.date = Date()
        updateDueDateLabel(with: dueDatePickerView.date)
        updateSaveButtonState()
    }

    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        updateDueDateLabel(with: dueDatePickerView.date)
    }
    
    
    
    
    /// Disable the save button if there is no title.
    func updateSaveButtonState() {
        let text = amountTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    /// Update the due date label to match the date from the date picker.
    /// - parameter date: The actual date from the data picker.
    func updateDueDateLabel(with date: Date) {
        dueDateLabel.text = Expense.dueDateFormatter.string(from: date)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "saveUnwind" {
            if let _ = Float(amountTextField.text!) {
                return true
            } else {
                let alert = UIAlertController(title: "Fout!", message: "Voer een juist getal in.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            return true
        }
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
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        navigationItem.title = categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}
