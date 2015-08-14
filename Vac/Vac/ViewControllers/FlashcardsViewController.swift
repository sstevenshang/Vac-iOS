//
//  FlashcardsViewController.swift
//  Vac
//
//  Created by Steven Shang on 8/14/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import RealmSwift

class FlashcardsViewController: UIViewController {

    @IBOutlet weak var flashCard: UIView!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var sentenceLabel: UILabel!
    
    @IBAction func noButtonTouched(sender: AnyObject) {
        checkIfFinished()
        
    }
    
    @IBAction func yesButtonTouched(sender: AnyObject) {
        checkIfFinished()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWords()
        sentenceLabel.hidden = true
        wordCount = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var words = [Word]()
    
    func getWords() {
        
        let realm = Realm()
        var savedWords = realm.objects(Word)
        
        for savedWord in savedWords {
            let aString = savedWord
            if !contains(words, aString) {
                words.append(aString)
            }
        }
        
        words = shuffle(words)
        println("got words")
    }
    
    var wordCount: Int = 0
    
    func checkIfFinished() {
        
        if wordCount > words.count{
            
            flashCard.hidden = true
            sentenceLabel.hidden = false
            wordCount = 0
            
        } else {
            
            wordCount++
        }
    }
    
    
    
    
    
    
    
    func assignWord(wordCount: Int) -> Word{
        
        return words[wordCount]
    }
    
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let c = count(list)
        if c < 2 { return list }
        for i in 0..<(c - 1) {
            let j = Int(arc4random_uniform(UInt32(c - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
    
    func reloadData() {
        
        assignWord()
        
        performSegueWithIdentifier("childView", sender: FlashcardsViewController.self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "childView" {
            let destination = segue.destinationViewController as! Flashcard
        }
    }
    
}
