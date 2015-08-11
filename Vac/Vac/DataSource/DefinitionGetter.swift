//
//  DefinitionGetter.swift
//  Vac
//
//  Created by Steven Shang on 8/11/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import SwiftyJSON

class DefinitionGetter {
    
    let dictionary = DictionaryHelper()
    
    func getDefinition(word: String, completionHandler: (WordStruct -> Void)) {
        
        var partOfSpeech = [String]()
        var definitions = [String]()
        var synonyms: String = ""
        var example: String = ""
        
        let format = FormatString()
        
        dictionary.callSession(word, type: "definition", completionBlock: {(data: NSData) -> Void in
            
            let json = JSON(data: data)
            
            for (index: String, subJson: JSON) in json {
                
                if subJson["partOfSpeech"].stringValue != ""{
                    
                    partOfSpeech.append(subJson["partOfSpeech"].stringValue)
                    
                    let definition: String = format.modifyDefinition(subJson["text"].stringValue)
                    
                    definitions.append(definition)
                    
                }
            }
            
            self.dictionary.callSession(word, type: "synonyms", completionBlock: {(data: NSData) -> Void in
                
                let json = JSON(data: data)
                let anyWord = json[0]
                let anyWords = anyWord["words"]
                
                var synonymsArray: [String] = []
                
                for (index: String, subJson: JSON) in anyWords {
                    
                    let synonym: String = format.modifySynonym(subJson.stringValue)
                    synonymsArray.append(synonym)
                    
                }
                
                synonyms = ", ".join(synonymsArray)
                
                self.dictionary.callSession(word, type: "example", completionBlock: {(data: NSData) -> Void in
                    
                    let json = JSON(data: data)
                    let anyJson = json["examples"]
                    let anyAnyJson = anyJson[0]
                    
                    example = format.modifyExample(anyAnyJson["text"].stringValue)
                    
                    var thisWord = WordStruct(word: word, partOfSpeech: partOfSpeech, definitions: definitions, synonyms: synonyms, example: example)
                    
                    completionHandler(thisWord)
                    
                })
            })
        })
    }
    
    
}
