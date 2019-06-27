//
//  AddCategoryViewController.swift
//  WegGeld
//
//  Created by Noud on 6/17/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* Class which is used to edit a exisiting category or add a new category. */
class AddCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Initialization of the IBOutlets.
    @IBOutlet weak var boundaryBox: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    // MARK: - Initialization of local variables
    var appData: AppData!
    var categoryLabel: String?
    var colors = UIColor.categoryColors()
    var indexPaths = [IndexPath]()
    var selectedColor = Int()

    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        nameField.addTarget(self, action: #selector(self.returnPressed(_:)), for: .primaryActionTriggered)
        boundaryBox.backgroundColor = UIColor.light_pink

        collectionView.delegate = self
        collectionView.dataSource = self
        
        appData = AppData.loadAppData()
        
    }
    
    // MARK: - objc functions
    /// If the user presses 'Return' it removes the keyboard.
    @objc func returnPressed(_ sender: UITextField) {
        self.view.endEditing(true)
    }
    
    /// Sents an alert with the given message.
    private func sentAlert(message: String) {
        let alert = UIAlertController(title: "Fout!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Checks if a category can be saved.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier == "saveCategory" else { return true }

        let name = nameField.text!.capitalizingFirstLetter()
        // If nameField is empty.
        if name.isEmpty {
            // Sents alert.
            sentAlert(message: "Voer een naam in.")
            return false
        // If entered category is an existing category.
        } else if appData.categories.contains(name) {
            // If the user is editing a category.
            if let _ = categoryLabel {
                return true
            } else {
                // Sents alert.
                sentAlert(message: "Deze categorie bestaat al.")
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveCategory" else { return }
        let name = nameField.text!.capitalizingFirstLetter()
        
        // If a category is changed.
        if let category = categoryLabel {
            appData.changeCategory(newName: name, prevName: category, color: selectedColor)
        // If a new category is added.
        } else {
            appData.addCategory(category: name, color: selectedColor)
        }
        AppData.saveAppData(appData)
    }

    // MARK: - Configurations for the collectionView
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        let view = cell.viewWithTag(1)!
        view.backgroundColor = colors[indexPath.row]
        
        // If the user is editing a category.
        if let label = categoryLabel {
            nameField.text = label
        }

        // If collectionViewCell is the selected category color, black box
        // around the selected color.
        if indexPath.row == selectedColor {
            cell.backgroundColor = UIColor.black
        } else {
            cell.backgroundColor = colors[indexPath.row]
        }
        // Stores all indexPaths for selecting cells using indexPaths.
        indexPaths.append(indexPath)
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt
        indexPath: IndexPath) {
        var selectedCell: UICollectionViewCell
        
        // If the user changed the color in the collectionView.
        if indexPath.row != selectedColor {
            // Removes black box around previous selected color.
            let previousIndexPath = indexPaths[selectedColor]
            selectedCell = collectionView.cellForItem(at: previousIndexPath as IndexPath)!
            selectedCell.contentView.backgroundColor = colors[selectedColor]
            
            // Creates black box around new selected color.
            selectedCell = collectionView.cellForItem(at: indexPath)!
            selectedCell.contentView.backgroundColor = UIColor.black

            selectedColor = indexPath.row
        }
    }
}
