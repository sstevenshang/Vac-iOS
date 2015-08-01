//
//  ViewController.swift
//  Vac
//
//  Created by Steven Shang on 7/20/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import SwiftyJSON

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

    @IBOutlet weak var saveButton: UIButton!

    
    
    // MARK: Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        resultTableView.hidden = true
        definitionView.hidden = true
        
        searchBar.delegate = self
        
        searchBar.attributedPlaceholder = NSAttributedString (string:"Search!", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        searchBar.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: Search Function
    
    let dictionary = DictionaryHelper()
    var searchResult: [String]?
    
    func textFieldDidChange(searchBar: UITextField) {
        
        if !searchBar.text.isEmpty{
            
            definitionView.hidden = true
            
            let searchWord = searchBar.text
            
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
    
    // MARK: Show Definition
    
    func getDefinition(word: String, completionHandler: (([String], definitons: [String], synonyms: [String], example: String) -> Void)) {
        
        wordLabel.text = word
        
        var partOfSpeech: [String] = []
        var definitions: [String] = []
        var synonyms: [String] = []
        var example: String = ""
        
        dictionary.callSession(word, type: "definition", completionBlock: {(data: NSData) -> Void in
            
            let json = JSON(data: data)
            
            for (index: String, subJson: JSON) in json {
                
                if subJson["partOfSpeech"].stringValue != ""{
                    
                    partOfSpeech.append(subJson["partOfSpeech"].stringValue)
                }
                
                definitions.append(subJson["text"].stringValue)
            }
            
            self.dictionary.callSession(word, type: "synonyms", completionBlock: {(data: NSData) -> Void in
                
                let json = JSON(data: data)
                let anyWord = json[0]
                let anyWords = anyWord["words"]
                
                for (index: String, subJson: JSON) in anyWords {
                    
                    synonyms.append(subJson.stringValue)
                }
                
                self.dictionary.callSession(word, type: "example", completionBlock: {(data: NSData) -> Void in
                    
                    let json = JSON(data: data)
                    let anyJson = json["examples"]
                    let anyAnyJson = anyJson[0]
                    
                    example = anyAnyJson["text"].stringValue
                    
                    completionHandler(partOfSpeech, definitons: definitions, synonyms: synonyms, example: example)
                    
                })
            })
        })
    }
    
    func handleDefinitionView(partOfSpeech:[String], definitions:[String], synonyms:[String], example: String) -> Void {
        
        println(partOfSpeech)
        println(definitions)
        println(synonyms)
        println(example)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.firstPartOfSpeech.text = partOfSpeech[0]
            self.firstDefinition.text = definitions[0]
            
            let numberOfDefinitions = partOfSpeech.count
            
            println(numberOfDefinitions)
            
            switch numberOfDefinitions {
                
            case 1:
                
                self.hideSecondSection(true)
                self.hideThirdSection(true)
                self.topConstraintOfSecondPartOfSpeech.constant = -107
                // default: 15
                
            case 2:
                
                self.secondPartOfSpeech.text = partOfSpeech[1]
                self.secondDefinition.text = definitions[1]
                
                self.hideSecondSection(false)
                self.hideThirdSection(true)
                self.topConstraintOfThirdPartOfSpeech.constant = -46
                // default: 15
                
            case 3:
                
                self.secondPartOfSpeech.text = partOfSpeech[1]
                self.secondDefinition.text = definitions[1]
                self.thirdPartOfSeech.text = partOfSpeech[2]
                self.thirdDefinition.text = definitions[2]
                
                self.hideSecondSection(false)
                self.hideThirdSection(false)
                
            default:
                
                println("oops")
                
            }
            
            if synonyms.count != 0 {

                var synonymsString: String = ", ".join(synonyms)
                self.synonymsLabel.text = synonymsString
                
                self.hideSynonyms(false)
                
            } else {
                
                self.hideSynonyms(true)
                self.topConstraintOfExampleTitle.constant = -48
                // default: 20

            }
            
            let modifiedExample = self.modifyExample(example)
            
            self.exampleLabel.text = modifiedExample
            
            self.definitionView.hidden = false
            println("definition view handled")

        })
        
    }
    
    func modifyExample(example: String) -> String {
        
        let newExample: String = example.stringByReplacingOccurrencesOfString("*", withString: "")
        let newNewExample: String = example.stringByReplacingOccurrencesOfString("_", withString: "")
        
        return newNewExample
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
    
    // MARK: Handle User Data
    
    func saveWord(partOfSpeech:[String], definitions:[String], synonyms:[String], example: String) {
        
     //   let word = Word()
        
        
        
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
            println(searchResult!.count)
            return searchResult!.count
        }
        else{
            println(0)
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let wordCell = tableView.dequeueReusableCellWithIdentifier("WordCell") as! WordCell
        
        if let result = searchResult?[indexPath.row] {
            
            wordCell.wordLabel.text = result
            println(result)
        }
        
        return wordCell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.topConstraintOfExampleTitle.constant = 20
        self.topConstraintOfThirdPartOfSpeech.constant = 15
        self.topConstraintOfSecondPartOfSpeech.constant = 15
        
        let wordSelected = searchResult![indexPath.row]
        
        searchBar.text = wordSelected
        
        getDefinition(wordSelected, completionHandler: self.handleDefinitionView)
        
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








