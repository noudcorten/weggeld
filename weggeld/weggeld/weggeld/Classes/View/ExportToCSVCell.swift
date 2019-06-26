//
//  ExportToCSVCell.swift
//  WegGeld
//
//  Created by Noud on 6/21/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

class ExportToCSVCell: UITableViewCell {
    
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
