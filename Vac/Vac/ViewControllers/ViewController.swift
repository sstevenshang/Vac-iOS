//
//  ViewController.swift
//  Vac
//
//  Created by Steven Shang on 7/20/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import DOFavoriteButton
import Mixpanel

class ViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var resultTableView: UITableView!
    
    // MARK: Word Definition View
    
    @IBOutlet weak var definitionView: UIScrollView!
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var firstPartOfSpeech: UILabel!
    
    @IBOutlet weak var firstDefinition: UILabel!
    
    @IBOutlet weak var secondPartOfSpeech: UILabel!
    
    @IBOutlet weak var secondDefinition: UILabel!
    
    @IBOutlet weak var thirdPartOfSeech: UILabel!
    
    @IBOutlet weak var thirdDefinition: UILabel!
    
    @IBOutlet weak var synonymsLabel: UILabel!
    
    @IBOutlet weak var exampleLabel: UILabel!
    
    @IBOutlet weak var synonymsTitleLabel: UILabel!

    @IBOutlet weak var exampleTitleLabel: UILabel!
    
    @IBOutlet weak var topConstraintOfSecondPartOfSpeech: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraintOfThirdPartOfSpeech: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraintOfExampleTitle: NSLayoutConstraint!

    @IBOutlet weak var bigSaveButton: DOFavoriteButton!
    
    var wordShown = WordStruct(word: "", partOfSpeech: [], definitions: [], synonyms: "", example: "")
    
    // MARK: Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        resultTableView.hidden = true
        definitionView.hidden = true
        
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 15.0
        searchBar.attributedPlaceholder = NSAttributedString (string:"Search!", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        let clearButton = UIButton(frame: CGRectMake(0, 0, 15, 15))
        clearButton.setImage(UIImage(named: "ClearButton")!, forState: UIControlState.Normal)
        searchBar.rightView = clearButton
        clearButton.addTarget(self, action: "clear:", forControlEvents: UIControlEvents.TouchUpInside)
        searchBar.rightViewMode = UITextFieldViewMode.WhileEditing
        
        searchBar.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        bigSaveButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Dictionary launched")
        
        searchBar.becomeFirstResponder()
        
//        let realm = Realm()
//        realm.write{
//            self.realm.deleteAll()
//        }
//        println("all is lost, jump Jack.")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: Search Function
    
    func clear(clearButton: UIButton) {
        searchBar.text = ""
        resultTableView.hidden = true
        definitionView.hidden = true
        
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("ClearButton pressed")

    }
    
    let dictionary = DictionaryHelper()
    var searchResult: [String]?
    
    func textFieldDidChange(searchBar: UITextField) {
        
        if !searchBar.text.isEmpty{
            
            definitionView.hidden = true
            
            var searchWord = searchBar.text
            searchWord = searchWord.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            dictionary.callSession(searchWord, type: "words", completionBlock: { (data: NSData) -> Void in
                
                var wordsFound: [String] = []
                
                let json = JSON(data: data)
                let anyWord = json[("searchResults")]
                
                for (index: String, subJson: JSON) in anyWord {
                    
                    wordsFound.append(subJson["word"].stringValue)
                }
                
                self.searchResult = wordsFound
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.resultTableView.reloadData()
                    self.resultTableView.hidden = false
                })
            })
            
        } else {
            
            self.resultTableView.hidden = true
        }
    }
    
    // MARK: Save Button
    
    let realmHelper = RealmHelper()
    
    func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
            realmHelper.deleteRealm(wordShown.word)
            
            let mixpanel: Mixpanel = Mixpanel.sharedInstance()
            mixpanel.track("Deleted word", properties:["Button": "Dictionary page"])

        } else {
            // select with animation
            sender.select()
            realmHelper.writeRealm(wordShown)
            
            let mixpanel: Mixpanel = Mixpanel.sharedInstance()
            mixpanel.track("Saved word", properties:["Button": "Dictionary page"])
        }
    }
    
    let realm = Realm()
    
    func checkWordInRealm(word: String) -> Bool {
        
        if let aWord = realm.objectForPrimaryKey(Word.self, key: word){
            return true
        }
        return false
    }
    
    // MARK: Show Definition
    
    let definitionGetter = DefinitionGetter()
    
    func handleDefinitionView(thisWord: WordStruct) {
        
        wordShown = thisWord
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.firstPartOfSpeech.text = thisWord.partOfSpeech[0]
            self.firstDefinition.text = thisWord.definitions[0]
            
            let numberOfDefinitions = thisWord.partOfSpeech.count
            
            switch numberOfDefinitions {
                
            case 1:
                self.hideSecondSection(true)
                self.hideThirdSection(true)
                self.topConstraintOfSecondPartOfSpeech.constant = -107
                // default: 15
                
            case 2:
                self.secondPartOfSpeech.text = thisWord.partOfSpeech[1]
                self.secondDefinition.text = thisWord.definitions[1]
                self.hideSecondSection(false)
                self.hideThirdSection(true)
                self.topConstraintOfThirdPartOfSpeech.constant = -46
                // default: 15
                
            case 3:
                self.secondPartOfSpeech.text = thisWord.partOfSpeech[1]
                self.secondDefinition.text = thisWord.definitions[1]
                self.thirdPartOfSeech.text = thisWord.partOfSpeech[2]
                self.thirdDefinition.text = thisWord.definitions[2]
                self.hideSecondSection(false)
                self.hideThirdSection(false)
                
            default:
                
                println("poop")
            }
            
            if thisWord.synonyms != "" {
                
                self.synonymsLabel.text = thisWord.synonyms
                self.hideSynonyms(false)
                
            } else {
                
                self.hideSynonyms(true)
                self.topConstraintOfExampleTitle.constant = -48
                // default: 20
            }
            
            if thisWord.example != "" {
                
                self.hideExample(false)
                self.exampleLabel.text = thisWord.example
                
            } else {
                
                self.hideExample(true)
            }
            
            self.bigSaveButton.selected = self.checkWordInRealm(thisWord.word)
            self.definitionView.hidden = false

            
        })
    }
    
    func hideSecondSection(show: Bool) -> Void {
        
        self.secondPartOfSpeech.hidden = show
        self.secondDefinition.hidden = show
    }
    
    func hideThirdSection(show: Bool) -> Void {
        
        self.thirdDefinition.hidden = show
        self.thirdPartOfSeech.hidden = show
    }
    
    func hideSynonyms(show: Bool) -> Void {
        
        self.synonymsLabel.hidden = show
        self.synonymsTitleLabel.hidden = show
    }
    
    func hideExample(show: Bool) -> Void {
        
        self.exampleTitleLabel.hidden = show
        self.exampleLabel.hidden = show
    }
    
    
    // MARK: Guillotine Menu
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showMenu") {
            
            let destinationVC = segue.destinationViewController as! GuillotineMenuViewController
            destinationVC.hostNavigationBarHeight = self.navigationController!.navigationBar.frame.size.height
            destinationVC.view.backgroundColor = self.navigationController!.navigationBar.barTintColor
            destinationVC.setMenuButtonWithImage(menuButton.imageView!.image!)
            
        }
    }
}

// MARK: TableView

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchResult != nil{

            return searchResult!.count
        }
        else{

            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let wordCell = tableView.dequeueReusableCellWithIdentifier("WordCell") as! WordCell
        
        if let result = searchResult?[indexPath.row] {
            
            wordCell.word = result
            wordCell.wordLabel.text = result
            wordCell.saveButton.selected = checkWordInRealm(result)
            
        }
        
        return wordCell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Clicked on cell", properties:["View controller": "Dictionary"])
        
        self.topConstraintOfExampleTitle.constant = 20
        self.topConstraintOfThirdPartOfSpeech.constant = 15
        self.topConstraintOfSecondPartOfSpeech.constant = 15
        
        let wordSelected = searchResult![indexPath.row]
        
        searchBar.text = wordSelected
        wordLabel.text = wordSelected
        
        definitionGetter.getDefinition(wordSelected, completionHandler: self.handleDefinitionView)
        
        searchBar.resignFirstResponder()
        
        resultTableView.hidden = true
    }
    
}

// MARK: TextField

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(searchBar: UITextField) -> Bool{
        
        searchBar.resignFirstResponder()
        return true
        
    }
}



