//
//  RealmHelper.swift
//  Vac
//
//  Created by Steven Shang on 8/11/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import RealmSwift

class RealmHelper {
    
    func writeRealm(aWord: WordStruct) {
        
        let realm = Realm()
        let newWord = Word()
        
        newWord.handleData(aWord.word, partOfSpeech: aWord.partOfSpeech, definitions: aWord.definitions, synonyms: aWord.synonyms, example: aWord.example)
        
        realm.write {
            realm.add(newWord, update: true)
        }
        
        println("What did you add to my drink?!")
    }
    
    func deleteRealm(word: String) {
        
        let realm = Realm()
        let oldWord: Word = realm.objectForPrimaryKey(Word.self, key: word)!
        
        realm.write {
            realm.delete(oldWord.partOfSpeech)
            realm.delete(oldWord.definitions)
        }
        println("Got rid of them strings, let's party!")
        
        realm.write {
            realm.delete(oldWord)
        }
        println("3.2.1.. Sense of humor deleted.")
        
    }
    
}