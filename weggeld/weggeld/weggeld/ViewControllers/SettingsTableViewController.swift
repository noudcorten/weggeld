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
        if let inputMoney = Float(maxAmountTextField.text!) {
            appData!.maxAmount = inputMoney
            AppData.saveAppData(appData!)
        }
        saveButton.isEnabled = false
    }
    
    
    /// Disable the save button if there is no title.
    func updateSaveButtonState() {
        let text = maxAmountTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
        
        if let inputAmount = Float(text) {
            print(inputAmount)
            print(appData!.maxAmount)
            if inputAmount == appData!.maxAmount {
                print("disabled")
                saveButton.isEnabled = false
            }
        }
    }
    
    func updateTextField() {
        maxAmountTextField.text = String(appData!.maxAmount)
    }
    
    

}
