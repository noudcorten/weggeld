//
//  ExpenseInfoCell.swift
//  WegGeld
//
//  Created by Noud on 6/19/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* TableViewCell Class which is used in the ExpenseTableViewController. */
class ExpenseInfoCell: UITableViewCell {
    
    // Enables editing of the notesTextField.
    @IBOutlet weak var notesTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
