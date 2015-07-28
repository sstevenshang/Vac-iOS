//
//  WordCell.swift
//  Vac
//
//  Created by Steven Shang on 7/24/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit

class WordCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
