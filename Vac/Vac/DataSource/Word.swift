//
//  Word.swift
//  Vac
//
//  Created by Steven Shang on 7/27/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import RealmSwift

class Word: Object {
    
    dynamic var word: String = ""
    
    var partOfSpeech = List<RealmString>()
    
    var definitions = List<RealmString>()
    
    dynamic var synonyms: String = ""
    
    dynamic var example: String = ""
    
    func handleData(word: String, partOfSpeech: [String], definitions: [String], synonyms: String, example: String) {
        
        self.word = word
        self.synonyms = synonyms
        self.example = example
        
        for aString in partOfSpeech {
            
            let aRealmString = RealmString()
            aRealmString.thisString = aString
            self.partOfSpeech.append(aRealmString)
        }
        
        for aString in definitions {
            
            let aRealmString = RealmString()
            aRealmString.thisString = aString
            self.definitions.append(aRealmString)
        }
    }
    
    override static func primaryKey() -> String? {
        return "word"
    }
    
}