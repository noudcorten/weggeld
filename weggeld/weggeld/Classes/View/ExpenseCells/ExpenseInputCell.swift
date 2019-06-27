//
//  ExpenseInputCell.swift
//  WegGeld
//
//  Created by Noud on 6/19/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* TableViewCell Class which is used in the ExpenseTableViewController. */
class ExpenseInputCell: UITableViewCell {
    
    // Enables editing of the amountTextField
    @IBOutlet weak var amountTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
