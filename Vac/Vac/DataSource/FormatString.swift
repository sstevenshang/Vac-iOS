//
//  FormatString.swift
//  Vac
//
//  Created by Steven Shang on 8/10/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit

class FormatString {
    
    func modifyExample(example: String) -> String {
        
        var newExample: String = example.stringByReplacingOccurrencesOfString("*", withString: "")
        newExample = newExample.stringByReplacingOccurrencesOfString("_", withString: "")
        newExample = newExample.stringByReplacingOccurrencesOfString("~", withString: "")
        newExample = newExample.stringByReplacingOccurrencesOfString("˜", withString: "")
        newExample = newExample.stringByReplacingOccurrencesOfString("™", withString: "")
        newExample = newExample.stringByReplacingOccurrencesOfString("-- ", withString: "")
        newExample = newExample.stringByReplacingOccurrencesOfString("　　 ", withString: "")
        newExample = newExample.stringByReplacingOccurrencesOfString("�", withString: "")
        
        return newExample
    }
    
    func modifySynonym(synonym: String) -> String {
        
        var newSynonym: String = synonym.stringByReplacingOccurrencesOfString("<er>", withString: "")
        newSynonym = newSynonym.stringByReplacingOccurrencesOfString("</er", withString: "")
        
        return newSynonym
    }
    
    func modifyDefinition(definition: String) -> String {
        
        var newDefinition: String = definition.stringByReplacingOccurrencesOfString("  ", withString: ": ")
        newDefinition = newDefinition.stringByReplacingOccurrencesOfString(":: ", withString: ": ")
        newDefinition = newDefinition.stringByReplacingOccurrencesOfString(": (", withString: " (")
        newDefinition = newDefinition.stringByReplacingOccurrencesOfString("( ", withString: "(")
        newDefinition = newDefinition.stringByReplacingOccurrencesOfString(".: ", withString: ".")
        
        return newDefinition
    }
    
}