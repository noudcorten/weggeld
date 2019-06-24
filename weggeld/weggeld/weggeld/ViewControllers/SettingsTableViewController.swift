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
    
    var downloadButton: UIButton?
    
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
        if gesture.direction == .right {
            self.tabBarController?.selectedIndex -= 1
        }
    }
    
    @objc func resetButtonPressed(sender: UIButton!) {
        showAlert(title: "Waarschuwing!", message: "Bij een 'Reset' zullen ALLE veranderingen in de app worden verwijderd.", optionOne: "Stop", optionTwo: "Reset", method: "Reset", category: nil, indexPath: nil)
    }
    
    @objc func downloadButtonPressed(sender: UIButton!) {
        let fileName = "Uitgaves.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "Datum,Bedrag,Categorie,Extra info\n"
        for expense in appData.expenses {
            let newLine = "\(expense.dueDate),\(expense.amount),\(expense.category),\(expense.notes ?? "")\n"
            csvText.append(contentsOf: newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
            vc.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToTwitter,
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.openInIBooks
            ]
            present(vc, animated: true, completion: nil)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    private func setupSwipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
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
    
    private func showAlert(title: String, message: String, optionOne: String, optionTwo: String, method: String, category: String?, indexPath: IndexPath?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: optionOne, style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: optionTwo, style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            switch method {
            case "Remove":
                self.removeCategory(category: category!, indexPath: indexPath!)
            case "Reset":
                self.appData.reset()
                AppData.saveAppData(self.appData)
                self.tableView.reloadData()
            default:
                return
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func removeCategory(category: String, indexPath: IndexPath) {
        self.appData.removeCategory(category: category)
        AppData.saveAppData(self.appData)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    private func getUI(type: String) -> UIView? {
        let frame_width = Int(self.view.frame.size.width)
        let x_offset = 10
        let y_offset = 2
        let label_boxWidth = 200
        let button_boxWidth = 85
        let label_boxHeight = 20
        let button_boxHeight = 25
        
        switch type {
        case "View":
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: frame_width, height: label_boxHeight)
            view.backgroundColor = UIColor.light_pink
            return view
        case "Label":
            let label = UILabel()
            label.textColor = UIColor.white
            label.frame = CGRect(x: x_offset, y: y_offset, width: label_boxWidth, height: label_boxHeight)
            return label
        case "Button":
            let button = UIButton()
            button.frame = CGRect(x: frame_width - button_boxWidth, y: 0, width: button_boxWidth, height: button_boxHeight)
            button.backgroundColor = UIColor.dark_pink
            button.setTitle("Reset", for: .normal)
            button.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
            return button
        default:
            return nil
        }
        
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
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return appData.categories.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(25)
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
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            
            let category = appData.categories[indexPath.row]
            cell.categoryLabel.text = category
            
            let colors = UIColor.categoryColors()
            let pickedColor = appData.category_dict[category]!
            cell.colorView.backgroundColor = colors[pickedColor]
            
            let radius = cell.colorView.frame.height / 2
            cell.colorView.layer.cornerRadius = radius
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExportCell", for: indexPath) as! ExportToCSVCell
            cell.selectionStyle = .none
            cell.downloadLabel.text = "Download .csv file"
            downloadButton = cell.downloadButton
            downloadButton!.setTitle("Download", for: .normal)
            downloadButton!.addTarget(self, action: #selector(downloadButtonPressed), for: .touchUpInside)
            return cell
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 1:
            return true
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = getUI(type: "View")!
        let label = getUI(type: "Label") as! UILabel
        
        switch section {
        case 0:
            label.text = "Maximale Bedrag"
        case 1:
            label.text = "Categorieën"
            let button = getUI(type: "Button") as! UIButton
            view.addSubview(button)
        default:
            label.text = "Extra opties"
        }
        
        view.addSubview(label)
        return view
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var categories = appData.categories
            let category = categories[indexPath.row]
            
            if appData.hasCategory(category) {
                showAlert(title: "Waarschuwing!", message: "Het verwijderen van deze categorie zal alle uitgaves in deze categorie verwijderen.", optionOne: "Stop", optionTwo: "Verwijder", method: "Remove", category: category, indexPath: indexPath)
            } else {
                removeCategory(category: category, indexPath: indexPath)
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
