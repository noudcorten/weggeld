//
//  SettingsTableViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var appData: AppData?
    var maxAmountTextField: UITextField?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        navigationItem.leftBarButtonItem = editButtonItem
//        self.navigationController!.navigationBar.tintColor = UIColor.lightGray
        self.hideKeyboardWhenTappedAround()
        
        
        appData = AppData.loadAppData()
        tableView.reloadData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("changed!")
        updateSaveButtonState()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        view.endEditing(true)
        var text = maxAmountTextField!.text!
        if text.contains(",") {
            text = text.replacingOccurrences(of: ",", with: ".")
            maxAmountTextField!.text = text
        }
        
        if inputIsFloat(input: text) {
            saveInputMoney(input: text)
        } else if inputIsInt(input: text) {
            saveInputMoney(input: text)
        } else {
            let alert = UIAlertController(title: "Fout!", message: "Voer een juist getal in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func inputIsInt(input: String) -> Bool {
        if let _ = Int(input) {
            return true
        }
        return false
    }
    
    private func inputIsFloat(input: String) -> Bool {
        if let _ = Float(input) {
            let dotString = "."
            if input.contains(dotString) {
                // Input is float with a maximum of two decimals
                if input.components(separatedBy: dotString)[1].count <= 2 {
                    return true
                }
            }
        }
        return false
    }
    
    private func saveInputMoney(input: String) {
        let inputMoney = Float(input)
        appData!.maxAmount = abs(inputMoney!)
        AppData.saveAppData(appData!)
        saveButton.isEnabled = false
    }
    
    /// Disable the save button if there is no title.
    private func updateSaveButtonState() {
        let text = maxAmountTextField!.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
        if let inputAmount = Float(text) {
            if inputAmount == appData!.maxAmount {
                saveButton.isEnabled = false
            }
        }
    }
    
    private func updateTextField() {
        let maxAmount = appData!.maxAmount
        
        if floor(maxAmount) == maxAmount {
            maxAmountTextField!.text = String(Int(maxAmount))
        } else {
            maxAmountTextField!.text = String(maxAmount)
        }
        
        maxAmountTextField!.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                     for: UIControl.Event.editingChanged)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return appData!.categories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputCell
            cell.inputField.delegate = self as? UITextFieldDelegate
            maxAmountTextField = cell.inputField
            updateTextField()
            updateSaveButtonState()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            
            let category = appData!.categories[indexPath.row]
            cell.categoryLabel.text = category
            
            let colors = UIColor.categoryColors()
            let pickedColor = appData!.category_dict[category]!
            cell.colorView.backgroundColor = colors[pickedColor]
            
            let radius = cell.colorView.frame.height / 2
            cell.colorView.layer.cornerRadius = radius
            
            return cell
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        default:
            return true
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
            label.text = "MAXIMALE BEDRAG"
        default:
            label.text = "CATEGORIEËN"
        }
        
        view.addSubview(label)
        return view
    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = "joehoe"
//        return label
//    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var categories = appData!.categories
            let category = categories[indexPath.row]
            
            appData!.removeCategory(category: category)
            AppData.saveAppData(appData!)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let addCategoryController = segue.destination as! AddCategoryViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let category = appData!.categories[indexPath.row]
            addCategoryController.selectedColor = appData!.category_dict[category]!
            addCategoryController.categoryLabel = category
        }
    }
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {
        appData = AppData.loadAppData()
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            tableView.reloadData()
        }
    }
}
