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
    
    dynamic var partOfSpeech: [String] = []
    
    dynamic var definitions: [String] = []
    
    dynamic var synonyms: [String] = []
    
    dynamic var example: String = ""
    
}
