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
    
    var word: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        saveButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let definitionGetter = DefinitionGetter()
    let realmHelper = RealmHelper()
    
    var wordSaved = WordStruct(word: "", partOfSpeech: [], definitions: [], synonyms: "", example: "")
    
    func tapped(sender: DOFavoriteButton) {
        
        println("tapped")
        
        if sender.selected {
            
            sender.deselect()

            realmHelper.deleteRealm(word)
            
        } else {
            
            sender.select()
            
            if wordSaved.word != word {
                println("finding word now")
                definitionGetter.getDefinition(word, completionHandler: { (wordFound: WordStruct) -> Void in
                    self.wordSaved = wordFound
                    println("word found")
                    self.realmHelper.writeRealm(wordFound)
                })
            } else {
                println("word's there, just save it")
                realmHelper.writeRealm(wordSaved)
            }
            
        }
    }
}
