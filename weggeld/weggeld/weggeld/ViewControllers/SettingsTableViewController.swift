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
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {
        appData = AppData.loadAppData()
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            tableView.reloadData()
        }
    }
    
    var appData: AppData!
    var maxAmountTextField: UITextField?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        appData = AppData.loadAppData()
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setupSwipeRecognizer()
        self.setupNavigationBar()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 3 { // set your total tabs here
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
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
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem!.title = "Wijzig"
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
        appData.maxAmount = abs(inputMoney!)
        AppData.saveAppData(appData)
        saveButton.isEnabled = false
    }
    
    /// Disable the save button if there is no title.
    private func updateSaveButtonState() {
        let text = maxAmountTextField!.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
        if let inputAmount = Float(text) {
            if inputAmount == appData.maxAmount {
                saveButton.isEnabled = false
            }
        }
    }
    
    private func updateTextField() {
        let maxAmount = appData.maxAmount
        
        if floor(maxAmount) == maxAmount {
            maxAmountTextField!.text = String(Int(maxAmount))
        } else {
            maxAmountTextField!.text = String(maxAmount)
        }
        
        maxAmountTextField!.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                     for: UIControl.Event.editingChanged)
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return appData.categories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputCell
            cell.selectionStyle = .none
            cell.inputField.delegate = self as? UITextFieldDelegate
            maxAmountTextField = cell.inputField
            updateTextField()
            updateSaveButtonState()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            
            let category = appData.categories[indexPath.row]
            cell.categoryLabel.text = category
            
            let colors = UIColor.categoryColors()
            let pickedColor = appData.category_dict[category]!
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
        view.backgroundColor = UIColor.light_pink
        
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.frame = CGRect(x: 10, y: 3, width: 200, height: 20)
        
        switch section {
        case 0:
            label.text = "Maximale Bedrag"
        default:
            label.text = "Categorieën"
        }
        
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(10)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var categories = appData.categories
            let category = categories[indexPath.row]
            
            if appData.hasCategory(category) {
                let alert = UIAlertController(title: "Waarschuwing!", message: "Het verwijderen van deze categorie zal alle uitgaves in deze categorie verwijderen.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Stop", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                    return
                }))
                alert.addAction(UIAlertAction(title: "Doorgaan", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                    self.appData.removeCategory(category: category)
                    AppData.saveAppData(self.appData)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.appData.removeCategory(category: category)
                AppData.saveAppData(self.appData)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        default:
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movingCategory = appData.categories[sourceIndexPath.row]
        appData.categories.remove(at: sourceIndexPath.row)
        appData.categories.insert(movingCategory, at: destinationIndexPath.row)
        AppData.saveAppData(appData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let addCategoryController = segue.destination as! AddCategoryViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let category = appData.categories[indexPath.row]
            addCategoryController.selectedColor = appData.category_dict[category]!
            addCategoryController.categoryLabel = category
        }
    }
}
