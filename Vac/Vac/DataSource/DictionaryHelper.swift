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
    
    func createURL(key: String) -> NSURL{
        
        var URL = "http://api.wordnik.com:80/v4/words.json/search/\(key)*?caseSensitive=false&minCorpusCount=5&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=1&maxLength=-1&skip=0&limit=10&api_key=\(APIKey)"
        
        print("created url: ")
        println(URL)
        
        return NSURL(string: URL)!
        
    }
    
    let session = NSURLSession.sharedSession()
    
    func callSession(searchKey: String, completionBlock: (NSDictionary -> Void)) -> Void{

        var url = self.createURL(searchKey)
        
        let dataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if error != nil {
                
                NSLog(error.localizedDescription)
                
            } else {
                
                NSLog(NSString(data: data, encoding: NSUTF8StringEncoding)! as String)
                //let result = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String:String]
                //completionBlock(result!)
            }
            
        })
        
        dataTask.resume()
    }
}
