//
//  ListWordViewController.swift
//  Vac
//
//  Created by Steven Shang on 8/12/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import DOFavoriteButton
import RealmSwift

class ListWordViewController: UIViewController {
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var firstPartOfSpeech: UILabel!
    
    @IBOutlet weak var firstDefinition: UILabel!
    
    @IBOutlet weak var secondPartOfSpeech: UILabel!
    
    @IBOutlet weak var secondDefinition: UILabel!
    
    @IBOutlet weak var thirdPartOfSpeech: UILabel!
    
    @IBOutlet weak var thirdDefinition: UILabel!
    
    @IBOutlet weak var synonymLabel: UILabel!
    
    @IBOutlet weak var synonyms: UILabel!
    
    @IBOutlet weak var exampleLabel: UILabel!
    
    @IBOutlet weak var example: UILabel!
    
    @IBOutlet weak var bigSaveButton: DOFavoriteButton!
    
    @IBOutlet weak var topConstraintOnSecondPartOfSpeech: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraintOnThirdPartOfSpeech: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraintOnExampleTitle: NSLayoutConstraint!
    
    
    var word = Word()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleDefinitionView(word)
        println(word)
        
        bigSaveButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
    }

    let realmHelper = RealmHelper()
    
    func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
            
            realmHelper.deleteRealm(word.word)
            
        } else {
            // select with animation
            sender.select()
            
            let aWordStruct = turnWordIntoWordStruct(word)
            realmHelper.writeRealm(aWordStruct)
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDefinitionView(word: Word) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.wordLabel.text = word.word
            
            self.firstPartOfSpeech.text = word.partOfSpeech[0].thisString
            self.firstDefinition.text = word.definitions[0].thisString
            
            let numberOfDefinitions = word.partOfSpeech.count
            
            switch numberOfDefinitions {
                
            case 1:
                self.hideSecondSection(true)
                self.hideThirdSection(true)
                self.topConstraintOnSecondPartOfSpeech.constant = -107
                // default: 15
                
            case 2:
                self.secondPartOfSpeech.text = word.partOfSpeech[1].thisString
                self.secondDefinition.text = word.definitions[1].thisString
                self.hideSecondSection(false)
                self.hideThirdSection(true)
                self.topConstraintOnThirdPartOfSpeech.constant = -46
                // default: 15
                
            case 3:
                self.secondPartOfSpeech.text = word.partOfSpeech[1].thisString
                self.secondDefinition.text = word.definitions[1].thisString
                self.thirdPartOfSpeech.text = word.partOfSpeech[2].thisString
                self.thirdDefinition.text = word.definitions[2].thisString
                self.hideSecondSection(false)
                self.hideThirdSection(false)
                
            default:
                
                println("poop")
            }
            
            if word.synonyms != "" {
                
                self.synonyms.text = word.synonyms
                self.hideSynonyms(false)
                
            } else {
                
                self.hideSynonyms(true)
                self.topConstraintOnExampleTitle.constant = -48
                // default: 20
            }
            
            if word.example != "" {
                
                self.hideExample(false)
                self.example.text = word.example
                
            } else {
                
                self.hideExample(true)
            }
            
            self.bigSaveButton.selected = self.checkWordInRealm(word.word)
            
            println("I handled the body, don't worry.")
            
        })
    }
    
    func hideSecondSection(show: Bool) -> Void {
        
        self.secondPartOfSpeech.hidden = show
        self.secondDefinition.hidden = show
    }
    
    func hideThirdSection(show: Bool) -> Void {
        
        self.thirdDefinition.hidden = show
        self.thirdPartOfSpeech.hidden = show
    }
    
    func hideSynonyms(show: Bool) -> Void {
        
        self.synonyms.hidden = show
        self.synonymLabel.hidden = show
    }
    
    func hideExample(show: Bool) -> Void {
        
        self.exampleLabel.hidden = show
        self.example.hidden = show
    }
    
    let realm = Realm()
    
    func checkWordInRealm(word: String) -> Bool {
        
        if let aWord = realm.objectForPrimaryKey(Word.self, key: word){
            return true
        }
        return false
    }
    
    func turnWordIntoWordStruct(aWord: Word) -> WordStruct {
        
        var arrayPartOfSpeech = [String]()
        var arrayOfDefinitions = [String]()
        for part in aWord.partOfSpeech {
            arrayPartOfSpeech.append(part.thisString)
        }
        for definition in aWord.definitions {
            arrayOfDefinitions.append(definition.thisString)
        }
        let aWordStruct = WordStruct(word: aWord.word, partOfSpeech: arrayPartOfSpeech, definitions: arrayOfDefinitions, synonyms: aWord.synonyms, example: aWord.example)
        
        return aWordStruct
    }
    
    
    
    
}
