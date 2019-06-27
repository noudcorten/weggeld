//
//  SettingsTableViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* Class which controls maxAmount and categories. Also possible to download a
.csv file formed with the entered data. */
class SettingsTableViewController: UITableViewController {

    // MARK: - Initialization of the IBOutlets.
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        view.endEditing(true)
        
        // Cleans the string characters.
        var text = maxAmountTextField!.text!
        if text.contains(",") {
            text = text.replacingOccurrences(of: ",", with: ".")
            maxAmountTextField!.text = text
        }
        
        // Checks if text is a 'correct' float (not more than 2 decimals)
        if text.isFloat() {
            saveInputMoney(input: text)
        // If text is an 'incorrect' float it can still be an integer.
        } else if text.isInt() {
            saveInputMoney(input: text)
        } else {
            // Sends alert.
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
    
    // MARK: - Initialization of local variables
    var appData: AppData!
    var maxAmountTextField: UITextField?
    var downloadButton: UIButton?
    
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
        self.setupSwipeRecognizer()
        self.setupNavigationBar()
    }
    
    // MARK: - objc functions
    /// Calls checkAmountTextField() when a change is made to amountTextField.
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkMaxAmountTextField()
    }
    
    /// Changes the tab bar controller when the user swipes the screen.
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            self.tabBarController?.selectedIndex -= 1
        }
    }
    
    /// Sends an alert when the "Reset'-button is pressed.
    @objc func resetButtonPressed(sender: UIButton!) {
        showAlert(title: "Waarschuwing!", message: "Bij een 'Reset' zullen ALLE veranderingen in de app worden verwijderd.", optionOne: "Stop", optionTwo: "Reset", method: "Reset", category: nil, indexPath: nil)
    }
    
    /// Creates a .csv file of the data when the download button is pressed.
    @objc func downloadButtonPressed(sender: UIButton!) {
        let fileName = "Uitgaves.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "Datum,Bedrag,Categorie,Extra info\n"
        for expense in appData.expenses {
            // Turns the saved date into the correct format.
            let correctDate = DateFormatter.correctFormat.string(from: expense.dueDate)
            // Creates entry for the .csv file.
            let newLine = "\(correctDate),\(expense.amount),\(expense.category),\(expense.notes ?? "")\n"
            csvText.append(contentsOf: newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
            // Removes useless activity types.
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
    
    /// Let's the user swipe between tab bar controllers.
    private func setupSwipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    /// Set's the style of the navigation bar to the designed style.
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.gray
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem!.title = "Wijzig"
    }
    
    /// Prevents the user from inserting a number that's bigger than the
    /// defined maxAmount.
    private func checkForMaxAmount(_ amount: Float) {
        if amount > maxAmount {
            let alert = UIAlertController(
                title: "Fout!",
                message: "Getal mag niet groter zijn dan 1.000.000",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            
            var text = maxAmountTextField!.text!
            text.remove(at: text.index(before: text.endIndex))
            maxAmountTextField!.text = text
        }
    }

    /// If the inputText is correct it saved in AppData.
    private func saveInputMoney(input: String) {
        let inputMoney = Float(input)
        appData.maxAmount = abs(inputMoney!)
        AppData.saveAppData(appData)
        saveButton.isEnabled = false
    }
    
    /// Disable the save button if there is no title.
    private func checkMaxAmountTextField() {
        let text = maxAmountTextField!.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
        if let inputAmount = Float(text) {
            checkForMaxAmount(inputAmount)
            if inputAmount == appData.maxAmount {
                saveButton.isEnabled = false
            }
        }
    }
    
    /// Fills the maxAmountTextField with a value depending on the way it can
    /// be written (prefers integer, else float).
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
    
    /// Creates an alert with two options, using the given configurations.
    private func showAlert(title: String, message: String, optionOne: String,
                           optionTwo: String, method: String, category: String?,
                           indexPath: IndexPath?) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: optionOne, style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(
            title: optionTwo, style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            // Depending on given method, change button actions.
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
    
    /// Removes a given category from AppData.
    private func removeCategory(category: String, indexPath: IndexPath) {
        self.appData.removeCategory(category: category)
        AppData.saveAppData(self.appData)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    /// Returns either a UIView, UILabel or UIButton depending on given type.
    private func getUI(type: String) -> UIView? {
        // Standard view configurations.
        let frame_width = Int(self.view.frame.size.width)
        let x_offset = 10
        let y_offset = 2
        let label_boxWidth = 200
        let button_boxWidth = 85
        let label_boxHeight = 20
        let button_boxHeight = 25
        
        // Switch witch decide what to return in the function.
        switch type {
        case "View":
            // Creates UIView (used for header).
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: frame_width, height: label_boxHeight)
            view.backgroundColor = UIColor.light_pink
            return view
        case "Label":
            // Creates UILabel (added to view of the header).
            let label = UILabel()
            label.textColor = UIColor.white
            label.frame = CGRect(x: x_offset, y: y_offset, width: label_boxWidth, height: label_boxHeight)
            return label
        case "Button":
            // Creates UIButton (added to view of the header).
            let button = UIButton()
            button.frame = CGRect(x: frame_width - button_boxWidth, y: 0, width: button_boxWidth, height: button_boxHeight)
            button.backgroundColor = UIColor.dark_pink
            button.setTitle("Reset", for: .normal)
            // Adds target for pressing the 'Reset'-Button
            button.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
            return button
        default:
            return nil
        }
        
    }
    
    /// If the table view is in editing mode, the label is changed to it's
    /// corresponding title.
    override func setEditing (_ editing:Bool, animated:Bool) {
        super.setEditing(editing,animated:animated)
        if self.isEditing {
            self.editButtonItem.title = "Klaar"
        } else {
            self.editButtonItem.title = "Wijzig"
        }
    }
    
    // MARK: - Configurations for the TableView.
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = getUI(type: "View")!
        let label = getUI(type: "Label") as! UILabel
        
        // Creates the three different sections.
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // InputCell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputCell
            // Sets the cell IBOutlets to local variables.
            cell.inputField.delegate = self as? UITextFieldDelegate
            maxAmountTextField = cell.inputField
            
            // Updates the values in TableView.
            updateTextField()
            checkMaxAmountTextField()
            return cell
            
        // CategoryCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            
            // Updates the category labels.
            let category = appData.categories[indexPath.row]
            cell.categoryLabel.text = category
            
            // Sets the colorView to the color corresponding to the category.
            let colors = UIColor.categoryColors()
            let pickedColor = appData.category_dict[category]!
            cell.colorView.backgroundColor = colors[pickedColor]
            
            // Changes the UIView to a circle.
            let radius = cell.colorView.frame.height / 2
            cell.colorView.layer.cornerRadius = radius
            return cell
            
        // ExportCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExportCell", for: indexPath) as! ExportToCSVCell
            // Sets the cell IBOutlets to local variables.
            downloadButton = cell.downloadButton
            downloadButton!.setTitle("Download", for: .normal)
            // Add action for downloadButtonPressed.
            downloadButton!.addTarget(self, action: #selector(downloadButtonPressed), for: .touchUpInside)
            cell.downloadLabel.text = "Download .csv file"
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 1:
            return true
        default:
            return false
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // If the user wants to delete a cell.
        if editingStyle == .delete {
            var categories = appData.categories
            let category = categories[indexPath.row]
            
            // Sends alert if category is used in a expense.
            if appData.hasCategory(category) {
                showAlert(title: "Waarschuwing!", message: "Het verwijderen van deze categorie zal alle uitgaves in deze categorie verwijderen.", optionOne: "Stop", optionTwo: "Verwijder", method: "Remove", category: category, indexPath: indexPath)
            } else {
                removeCategory(category: category, indexPath: indexPath)
            }
        }
    }
    
    /// Makes it able to move the category rows.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 1:
            return true
        default:
            return false
        }
    }
    
    /// Changes the values of the categories if a category cell is moved.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movingCategory = appData.categories[sourceIndexPath.row]
        appData.categories.remove(at: sourceIndexPath.row)
        appData.categories.insert(movingCategory, at: destinationIndexPath.row)
        AppData.saveAppData(appData)
    }
    
    /// Prevents a cell to be added to another section.
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let sourceSection = sourceIndexPath.section
        let destSection = proposedDestinationIndexPath.section
        
        if destSection < sourceSection {
            return IndexPath(row: 0, section: sourceSection)
        } else if destSection > sourceSection {
            return IndexPath(row: self.tableView(tableView, numberOfRowsInSection:sourceSection)-1, section: sourceSection)
        }
        return proposedDestinationIndexPath
    }
    
    /// If the user wants to edit a category a segue is called.
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
