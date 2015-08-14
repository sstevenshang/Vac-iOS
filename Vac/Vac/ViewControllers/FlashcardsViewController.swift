//
//  FlashcardsViewController.swift
//  Vac
//
//  Created by Steven Shang on 8/14/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import RealmSwift
import Mixpanel

class FlashcardsViewController: UIViewController {

    @IBOutlet weak var flashCard: UIView!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var sentenceLabel: UILabel!
    
    @IBOutlet weak var anotherSentenceLabel: UILabel!
    
    @IBOutlet weak var replayButton: UIButton!
    
    @IBAction func replayButtonTouched(sender: AnyObject) {
        
        words = shuffle(words)
        hideEverything(false)
        reloadData()
    
    }
    
    @IBAction func noButtonTouched(sender: AnyObject) {
        checkIfFinished()
        
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Flashcard Played", properties:["Button": "No"])
    }
    
    @IBAction func yesButtonTouched(sender: AnyObject) {
        checkIfFinished()
        
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Flashcard Played", properties:["Button": "Yes"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Flashcard Launched")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

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

    }
    
    var wordCount: Int = 0
    
    func checkIfFinished(){
        
        if wordCount == (words.count - 1){
            
            hideEverything(true)
            wordCount = 0
            
            let mixpanel: Mixpanel = Mixpanel.sharedInstance()
            mixpanel.track("Finished all flashcards")
            
        } else {
            
            wordCount++
            reloadData()
        }
    }
    
    func assignWord(wordCount: Int) -> Word{
        
        return words[wordCount]
    }
    
    func reloadData() {
        
        let child = self.childViewControllers[0] as! Flashcard
        
        child.word = assignWord(wordCount)
        child.handleView()
    }
    
    func hideEverything(show: Bool) {
        
        flashCard.hidden = show
        sentenceLabel.hidden = !show
        anotherSentenceLabel.hidden = !show
        replayButton.hidden = !show
        yesButton.hidden = show
        noButton.hidden = show
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "childView" {
            
            if wordCount == 0{
                getWords()

            }
            
            if words.count != 0 {
                
                let destination = segue.destinationViewController as! Flashcard
                destination.word = assignWord(wordCount)
                hideEverything(false)
                
            } else {
                
                hideEverything(true)
            }
        }
    }
    
    // MARK: Random
    
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let c = count(list)
        if c < 2 { return list }
        for i in 0..<(c - 1) {
            let j = Int(arc4random_uniform(UInt32(c - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
    
}
