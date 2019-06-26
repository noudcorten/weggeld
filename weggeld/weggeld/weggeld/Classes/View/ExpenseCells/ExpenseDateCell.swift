//
//  ExpenseDateCell.swift
//  WegGeld
//
//  Created by Noud on 6/19/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* TableViewCell Class which is used in the ExpenseTableViewController. */
class ExpenseDateCell: UITableViewCell {
    
    // Enables editing of the dueDateLabel, pickerView and button.
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var todayButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
