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
    var colors = UIColor.categoryColors()
    var indexPaths = [IndexPath]()
    var selectedColor = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        appData = AppData.loadAppData()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier == "saveCategory" else { return true }
        
        let name = nameField.text!.capitalizingFirstLetter()
        if appData!.categories.contains(name) {
            let alert = UIAlertController(title: "Fout!", message: "Deze categorie bestaat al.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveCategory" else { return }
        
        let name = nameField.text!.capitalizingFirstLetter()
        
        appData!.addCategory(category: name, index: selectedColor)
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

        if indexPath.row == 0 {
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
        print(indexPath.row)
        
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

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
