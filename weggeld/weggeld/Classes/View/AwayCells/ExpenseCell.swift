//
//  ExpenseCell.swift
//  WegGeld
//
//  Created by Noud on 6/6/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* TableViewCell Class which is used in the AwayTableViewController. */
class ExpenseCell: UITableViewCell {

    // Enables editing of the expense-, category- & dateLabel and colorView.
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
