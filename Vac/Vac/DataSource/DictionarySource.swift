//
//  DictionarySource.swift
//  Vac
//
//  Created by Steven Shang on 7/21/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit

class DictionarySource: NSObject, HNKLookupDelegate {
    
    
    
    
    var lookUp = HNKLookup.sharedInstance()
    
    func getDefinition(word: String) {
        
        lookUp.definitionsForWord(word, completion: { (definitions: [AnyObject]!, error: NSError!) -> Void in
            
            if let error = error {
                NSLog("ERROR: \(error)")
            } else {
                for definition in definitions {
                    NSLog("\(definition)")
                    
                    
                    
                    
                    
                    
                }
            }
            
            
            
            
            
        })
        
    }
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    // HNKLookup Delegate
    
    func shouldDisplayNetworkActivityIndicator() -> Bool {
        return true
    }
    
}