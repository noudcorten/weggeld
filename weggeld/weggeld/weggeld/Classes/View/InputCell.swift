//
//  InputCell.swift
//  WegGeld
//
//  Created by Noud on 6/14/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* TableViewCell Class which is used in the Settings */
class InputCell: UITableViewCell {
    
    @IBOutlet weak var inputField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
