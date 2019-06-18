//
//  AddCategoryViewController.swift
//  WegGeld
//
//  Created by Noud on 6/17/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var appData: AppData?
    var categoryLabel: String?
    
    var colors = UIColor.categoryColors()
    var indexPaths = [IndexPath]()
    var selectedColor = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        appData = AppData.loadAppData()
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier == "saveCategory" else { return true }
        
        if let _ = categoryLabel {
            return true
        } else {
            let name = nameField.text!.capitalizingFirstLetter()
            if appData!.categories.contains(name) {
                let alert = UIAlertController(title: "Fout!", message: "Deze categorie bestaat al.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveCategory" else { return }
        let name = nameField.text!.capitalizingFirstLetter()
        
        if let category = categoryLabel {
            print(selectedColor)
            appData!.changeCategory(newName: name, prevName: category, color: selectedColor)
        } else {
            appData!.addCategory(category: name, color: selectedColor)
        }
        
        AppData.saveAppData(appData!)
    }
}

extension AddCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        let view = cell.viewWithTag(1)!
        view.backgroundColor = colors[indexPath.row]
        
        if let label = categoryLabel {
            nameField.text = label
        }

        if indexPath.row == selectedColor {
            cell.backgroundColor = UIColor.black
        } else {
            cell.backgroundColor = colors[indexPath.row]
        }
        
        indexPaths.append(indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt
        indexPath: IndexPath) {
        var selectedCell: UICollectionViewCell
        
        if indexPath.row != selectedColor {
            let previousIndexPath = indexPaths[selectedColor]
            selectedCell = collectionView.cellForItem(at: previousIndexPath as IndexPath)!
            selectedCell.contentView.backgroundColor = colors[selectedColor]
            
            selectedCell = collectionView.cellForItem(at: indexPath)!
            selectedCell.contentView.backgroundColor = UIColor.black

            selectedColor = indexPath.row
        }
    }
}
