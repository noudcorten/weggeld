//
//  ExpenseCategoryCell.swift
//  WegGeld
//
//  Created by Noud on 6/19/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* TableViewCell Class which is used in the ExpenseTableViewController. */
class ExpenseCategoryCell:
    UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Enables editing of the pickerView, colorView and categoryLabel.
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var appData: AppData?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        // Changes dataSource and delegate of pickerview to make it editable.
        pickerView!.dataSource = self
        pickerView!.delegate = self
        
        appData = AppData.loadAppData()
        configureColorView()
    }
    
    // Turns the UIView into a circle.
    private func configureColorView() {
        let radius = colorView.frame.height / 2
        colorView.layer.cornerRadius = radius
    }
    
    // MARK - Configurations of the pickerView.
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView,
                             numberOfRowsInComponent component: Int) -> Int {
        return appData!.categories.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                             inComponent component: Int) {
        // Gets the matching category name for the selected row.
        let category = appData!.categories[row]
        categoryLabel.text = category
        
        // Gets the matching color for the selected row.
        let colors = UIColor.categoryColors()
        let pickedColor = appData!.category_dict[category]!
        colorView.backgroundColor = colors[pickedColor]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                             forComponent component: Int) -> String? {
        return appData!.categories[row]
    }

}
