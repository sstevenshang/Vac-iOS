//
//  Word.swift
//  Vac
//
//  Created by Steven Shang on 7/27/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit

class Word: NSObject {
    
    let word: String
    
    let definition: [String:String]
    
    let synonyms: [String]
    
    let examples: [String]
    
    init(word: String, definition: [String:String], synonyms: [String], examples: [String]) {
        
        self.word = word
        self.definition = definition
        self.synonyms = synonyms
        self.examples = examples
        
    }
    
}
