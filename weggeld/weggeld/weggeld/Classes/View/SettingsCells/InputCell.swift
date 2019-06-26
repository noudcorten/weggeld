//
//  InputCell.swift
//  WegGeld
//
//  Created by Noud on 6/14/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* TableViewCell Class which is used in the SettingsTableViewController. */
class InputCell: UITableViewCell {
    
    // Enables reading of the UITextField
    @IBOutlet weak var inputField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
