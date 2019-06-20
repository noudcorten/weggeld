//
//  ExpenseTableViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class ExpenseTableViewController: UITableViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var amountTextField: UITextField?
    var dueDateLabel: UILabel?
    var dueDatePickerView: UIDatePicker?
    var categoryLabel: UILabel?
    var colorView: UIView?
    var pickerView: UIPickerView?
    var notesTextField: UITextField?
    
    var expense: Expense?
    var appData: AppData?
    var isExtraInfoHidden: Bool = true
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        self.hideKeyboardWhenTappedAround()
        
        appData = AppData.loadAppData()
        tableView.reloadData()
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
//        )
        
    }

//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            tableView.contentOffset = CGPoint(x: 0, y: keyboardRectangle.height)
//        }
//    }
//
//    @objc func keyboardWillHide(_ notification: Notification) {
//        tableView.contentOffset = CGPoint(x: 0, y: 0)
//    }
    
    @objc func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @objc func beginEditing(_ sender: UITextField) {
        tableView.contentOffset = CGPoint(x: 0, y: 40)
    }
    
    @objc func endEditing(_ sender: UITextField) {
        tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    @objc func returnPressed(_ sender: UITextField) {
        self.view.endEditing(true)
        tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    @objc func datePickerChanged(_ sender: Any) {
        updateDueDateLabel(with: dueDatePickerView!.date)
    }
    
    /// Disable the save button if there is no title.
    private func updateSaveButtonState() {
        let text = amountTextField!.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    /// Update the due date label to match the date from the date picker.
    /// - parameter date: The actual date from the data picker.
    private func updateDueDateLabel(with date: Date) {
        dueDateLabel!.text = Expense.dueDateFormatter.string(from: date)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(40)
        let largeCellHeight = CGFloat(200)
        
        switch indexPath.section {
        case 1:
            return largeCellHeight
        case 2:
            return largeCellHeight
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! ExpenseInputCell
            cell.selectionStyle = .none
            cell.amountTextField.delegate = self as? UITextFieldDelegate
            amountTextField = cell.amountTextField
            amountTextField!.addTarget(self, action: #selector(self.textEditingChanged(_:)), for: UIControl.Event.editingChanged)
            
            if let expense = expense {
                if floor(expense.amount) == expense.amount {
                    amountTextField!.text = String(Int(expense.amount))
                } else {
                    amountTextField!.text = String(expense.amount)
                }
            }
            
            updateSaveButtonState()
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath) as! ExpenseDateCell
            cell.selectionStyle = .none
            dueDateLabel = cell.dueDateLabel
            dueDatePickerView = cell.dueDatePickerView
            dueDatePickerView!.maximumDate = Date()
            dueDatePickerView!.addTarget(self, action: #selector(self.datePickerChanged), for: UIControl.Event.valueChanged)
            
            if let expense = expense {
                dueDatePickerView!.date = expense.dueDate
            } else {
                dueDatePickerView!.date = Date()
            }
            
            updateDueDateLabel(with: dueDatePickerView!.date)

            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! ExpenseCategoryCell
            cell.selectionStyle = .none
            pickerView = cell.pickerView
            categoryLabel = cell.categoryLabel
            colorView = cell.colorView
            
            let colors = UIColor.categoryColors()
            let category_dict = appData!.category_dict
            var category: String
            
            if let expense = expense {
                category = expense.category
            } else {
                category = appData!.categories[0]
            }
            
            categoryLabel!.text = category
            let index = category_dict[category]
            colorView!.backgroundColor = colors[index!]
            pickerView!.selectRow(appData!.categories.firstIndex(of: category)!, inComponent: 0, animated: true)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! ExpenseInfoCell
            cell.selectionStyle = .none
            cell.notesTextField.delegate = self as? UITextFieldDelegate
            notesTextField = cell.notesTextField
            notesTextField!.addTarget(self, action: #selector(self.beginEditing(_:)), for: .editingDidBegin)
            notesTextField!.addTarget(self, action: #selector(self.endEditing(_:)),
                                       for: .editingDidEnd)
            notesTextField!.addTarget(self, action: #selector(self.returnPressed(_:)), for: .primaryActionTriggered)
            
            if let expense = expense {
                notesTextField!.text = expense.notes
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.outlineStrokeColor
        
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.frame = CGRect(x: 10, y: 3, width: 200, height: 20)
        
        switch section {
        case 0:
            label.text = "UITGAVE"
        case 1:
            label.text = "DATUM"
        case 2:
            label.text = "CATEGORIE"
        default:
            label.text = "EXTRA INFO"
        }
        
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var text = amountTextField!.text!
        
        if text.contains(",") {
            text = text.replacingOccurrences(of: ",", with: ".")
            amountTextField!.text = text
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
        
        let amount = abs(Float(amountTextField!.text!)!)
        let dueDate = dueDatePickerView!.date
        let notes = notesTextField!.text
        let category = categoryLabel!.text!
        
        expense = Expense(amount: amount, dueDate: dueDate, notes: notes, category: category)
    }

}
