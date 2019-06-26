//
//  ExportToCSVCell.swift
//  WegGeld
//
//  Created by Noud on 6/21/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* TableViewCell Class which is used in the SettingsTableViewController. */
class ExportToCSVCell: UITableViewCell {
    
    // Enables editing of the downloadLabel and downloadButton.
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
