//
//  ExpenseCategoryCell.swift
//  WegGeld
//
//  Created by Noud on 6/19/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class ExpenseCategoryCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var appData: AppData?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView!.dataSource = self
        pickerView!.delegate = self
        
        appData = AppData.loadAppData()
        
        configureColorView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureColorView() {
        let radius = colorView.frame.height / 2
        colorView.layer.cornerRadius = radius
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appData!.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = appData!.categories[row]
        categoryLabel.text = category
        
        let colors = UIColor.categoryColors()
        let pickedColor = appData!.category_dict[category]!
        colorView.backgroundColor = colors[pickedColor]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return appData!.categories[row]
    }

}
