//
//  CategoryCell.swift
//  WegGeld
//
//  Created by Noud on 6/14/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* TableViewCell Class which is used in the SettingsTableViewController. */
class CategoryCell: UITableViewCell {
    
    // Enables editing of the categoryLabel and the colorView
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
