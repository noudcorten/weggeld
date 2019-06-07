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
        
        appData = AppData.loadAppData()!
        
        updateSaveButtonState()
        updateTextField()
        tableView.reloadData()
    }
    
    
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let text = maxAmountTextField.text!
        
        if let inputMoney = Float(text) {
            let dotString = "."
            if text.contains(dotString) {
                // Input is float with a maximum of two decimals
                if text.components(separatedBy: dotString)[1].count <= 2 {
                    appData!.maxAmount = abs(inputMoney)
                    AppData.saveAppData(appData!)
                    saveButton.isEnabled = false
                // Input is a float with more than two decimals
                } else {
                    let alert = UIAlertController(title: "Fout!", message: "Voer een juist getal in.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            // Input is an integer
            } else {
                appData!.maxAmount = abs(inputMoney)
                AppData.saveAppData(appData!)
                saveButton.isEnabled = false
            }
        }
    }
    
    
    /// Disable the save button if there is no title.
    func updateSaveButtonState() {
        let text = maxAmountTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
        if let inputAmount = Float(text) {
            if inputAmount == appData!.maxAmount {
                saveButton.isEnabled = false
            }
        }
    }
    
    func updateTextField() {
        let maxAmount = appData!.maxAmount
        
        if floor(maxAmount) == maxAmount {
            maxAmountTextField.text = String(Int(maxAmount))
        } else {
            maxAmountTextField.text = String(maxAmount)
        }
    }
}
