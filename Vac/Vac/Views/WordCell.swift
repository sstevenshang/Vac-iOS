//
//  WordCell.swift
//  Vac
//
//  Created by Steven Shang on 7/24/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import DOFavoriteButton
import Mixpanel

class WordCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var saveButton: DOFavoriteButton!
    
    var word: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        saveButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    let definitionGetter = DefinitionGetter()
    let realmHelper = RealmHelper()
    
    var wordSaved = WordStruct(word: "", partOfSpeech: [], definitions: [], synonyms: "", example: "")
    
    func tapped(sender: DOFavoriteButton) {
        
        if sender.selected {
            
            sender.deselect()
            realmHelper.deleteRealm(word)
            
            let mixpanel: Mixpanel = Mixpanel.sharedInstance()
            mixpanel.track("Deleted word", properties:["Button": "Cell"])
            
        } else {
            
            sender.select()
            
            let mixpanel: Mixpanel = Mixpanel.sharedInstance()
            mixpanel.track("Saved word", properties:["Button": "Cell"])
            
            if wordSaved.word != word {

                definitionGetter.getDefinition(word, completionHandler: { (wordFound: WordStruct) -> Void in
                    self.wordSaved = wordFound

                    self.realmHelper.writeRealm(wordFound)
                })
            } else {

                realmHelper.writeRealm(wordSaved)
            }
            
        }
    }
}
