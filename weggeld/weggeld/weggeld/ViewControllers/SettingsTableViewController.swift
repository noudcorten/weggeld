//
//  SettingsTableViewController.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var maxAmountTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var appData: AppData?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        appData = AppData.loadAppData()
        
        updateSaveButtonState()
        updateTextField()
        tableView.reloadData()
    }
    
    
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        var text = maxAmountTextField.text!
        if text.contains(",") {
            text = text.replacingOccurrences(of: ",", with: ".")
            maxAmountTextField.text = text
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
        let text = maxAmountTextField.text ?? ""
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
            maxAmountTextField.text = String(Int(maxAmount))
        } else {
            maxAmountTextField.text = String(maxAmount)
        }
    }
}
