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
        
        println("added!")
    }
    
    func deleteRealm(word: String) {
        
        let realm = Realm()
        let oldWord: Word = realm.objectForPrimaryKey(Word.self, key: word)!
        
        realm.write {
            realm.delete(oldWord.partOfSpeech)
            realm.delete(oldWord.definitions)
        }
        println("string deleted!")
        
        realm.write {
            realm.delete(oldWord)
        }
        println("deleted!")
        
    }
    
}