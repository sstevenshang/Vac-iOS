//
//  ListWordCell.swift
//  Vac
//
//  Created by Steven Shang on 8/12/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit

class ListWordCell: UITableViewCell {

    @IBOutlet weak var listWord: UILabel!
    
    @IBOutlet weak var listDefinition: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
