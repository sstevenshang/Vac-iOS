//
//  WordCell.swift
//  Vac
//
//  Created by Steven Shang on 7/24/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import DOFavoriteButton

class WordCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var saveButton: DOFavoriteButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        saveButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tapped(sender: DOFavoriteButton) {
        
        println("tapped")
        
        if sender.selected {
            
            sender.deselect()
        } else {
            
            sender.select()
        }
    }
    
}
