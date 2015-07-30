//
//  DictionaryHelper.swift
//  Vac
//
//  Created by Steven Shang on 7/24/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit

class DictionaryHelper: NSObject {
    
    let APIKey: String = "df9a5855e757622d54006058d830982c71a930d8b23d3cbd5"
    
    let session = NSURLSession.sharedSession()
    
    // SEARCH
    
    func createURL(key: String, type: String) -> NSURL{
        
        let newKey: String = key.stringByReplacingOccurrencesOfString(" ", withString: "_")
        
        var URL: String!
        
        switch type {
        
            case "words":
            
                URL = "http://api.wordnik.com/v4/words.json/search/\(newKey)*?caseSensitive=true&minCorpusCount=5&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=1&maxLength=-1&skip=0&limit=10&api_key=\(APIKey)"
            
            case "definition":
            
                URL = "http://api.wordnik.com:80/v4/word.json/\(newKey)/definitions?limit=3&includeRelated=true&sourceDictionaries=all&useCanonical=true&includeTags=false&api_key=\(APIKey)"
            
            case "synonyms":
                
                URL = "http://api.wordnik.com:80/v4/word.json/\(newKey)/relatedWords?useCanonical=true&relationshipTypes=synonym&limitPerRelationshipType=5&api_key=\(APIKey)"

            
            case "example":
            
                URL = "http://api.wordnik.com:80/v4/word.json/\(newKey)/topExample?useCanonical=false&api_key=\(APIKey)"
            
            default:
            
                URL = ""
        }
        
        println(URL)
        return NSURL(string: URL)!
        
    }
    
    func callSession(searchKey: String, type: String, completionBlock: (NSData -> Void)) -> Void{
        
        var url = self.createURL(searchKey, type: type)
        
        let dataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in

            if error != nil {
                
                NSLog(error.localizedDescription)
                
            } else {
                
                //println(NSString(data: data, encoding: NSUTF8StringEncoding))
                completionBlock(data)
            }
        })
        
        dataTask.resume()
    }
    
}
