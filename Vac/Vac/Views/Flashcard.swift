//
//  Flashcard.swift
//  Vac
//
//  Created by Steven Shang on 8/14/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit

class Flashcard: UIViewController {

    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var frontView: UIView!
    
    // MARK: Card
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var partOfSpeechLabel: UILabel!
    
    @IBOutlet weak var definitionLabel: UILabel!
    
    @IBOutlet weak var synonymsLabel: UILabel!
    
    @IBOutlet weak var tip: UILabel!
    
    var layer: CALayer {
        return mainView.layer
    }
    
    var word: Word?
    var hideTip: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.grayColor().CGColor
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3.0
        
        var touch = UITapGestureRecognizer(target:self, action:"tapped")
        mainView.addGestureRecognizer(touch)
        
        showingFront = true
        tip.hidden = hideTip
        
        if word != nil{
            handleView()
        }
        
    }
    
    var showingFront: Bool = true

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
        
    func tapped() {
        
        if showingFront {
            UIView.transitionFromView(frontView, toView: backView, duration: 0.5, options: .TransitionFlipFromLeft | .ShowHideTransitionViews , completion: nil)
            showingFront = false
            tip.hidden = true
        } else {
            UIView.transitionFromView(backView, toView: frontView, duration: 0.5, options: .TransitionFlipFromRight | .ShowHideTransitionViews , completion: nil)
            showingFront = true
        }

    }
    
    func handleView() {
        
        wordLabel.text = word!.word
        partOfSpeechLabel.text = constructPartOfSpeech(word!)
        definitionLabel.text = constructDefinition(word!)
        synonymsLabel.text = constructSynonyms(word!)
        
        UIView.transitionFromView(backView, toView: frontView, duration: 0, options: .ShowHideTransitionViews , completion: nil)
        showingFront = true
    }
    
    // MARK: Construction
    
    func constructPartOfSpeech(aWord: Word) -> String {
        
        var aString = String()
        var partOfSpeechArray = [String]()
        
        for partOfSpeech in aWord.partOfSpeech{
            
            let part = partOfSpeech.thisString
            if !contains(partOfSpeechArray, part){
                partOfSpeechArray.append(part)
            }
        }
        
        aString = "/".join(partOfSpeechArray)
        
        return aString
    }
    
    func constructDefinition(aWord: Word) -> String {
        
        var aString: String = aWord.definitions[0].thisString
        
        return aString
    }
    
    func constructSynonyms(aWord: Word) -> String {
        
        var aString = String()
        
        if aWord.synonyms != "" {
            aString += aWord.synonyms
        } else{
            aString = ""
        }
        
        return aString
    }

}
