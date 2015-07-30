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
    
    @IBOutlet weak var pageSaveButton: UIButton!
    
    @IBOutlet weak var firstPartOfSpeech: UILabel!
    
    @IBOutlet weak var firstDefinition: UILabel!
    
    @IBOutlet weak var secondPartOfSpeech: UILabel!
    
    @IBOutlet weak var secondDefinition: UILabel!
    
    @IBOutlet weak var thirdPartOfSeech: UILabel!
    
    @IBOutlet weak var thirdDefinition: UILabel!
    
    @IBOutlet weak var synonymsLabel: UILabel!
    
    @IBOutlet weak var exampleLabel: UILabel!
    
    @IBOutlet weak var synonymsTitleLabel: UILabel!

    @IBOutlet weak var topConstraintOfSecondPartOfSpeech: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraintOfThirdPartOfSpeech: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraintOfExample: NSLayoutConstraint!

    func getDefinition(word: String) {
        
        wordLabel.text = word
        
        var partOfSpeech: [String] = []
        var definitions: [String] = []
        var synonyms: [String] = []
        var example: String = ""
        
        dictionary.callSession(word, type: "definition", completionBlock: {(data: NSData) -> Void in
            
            let json = JSON(data: data)
            
            for (index: String, subJson: JSON) in json {
                
                partOfSpeech.append(subJson["partOfSpeech"].stringValue)
                definitions.append(subJson["text"].stringValue)
            }
            
            println(partOfSpeech)
            println(definitions)
            
            self.dictionary.callSession(word, type: "synonyms", completionBlock: {(data: NSData) -> Void in
                
                let json = JSON(data: data)
                let anyWord = json[0]
                let anyWords = anyWord["words"]
                
                for (index: String, subJson: JSON) in anyWords {
                    
                    synonyms.append(subJson.stringValue)
                }
                
                println(synonyms)
                
                self.dictionary.callSession(word, type: "example", completionBlock: {(data: NSData) -> Void in
                    
                    let json = JSON(data: data)
                    example = json["text"].stringValue
                    
                    example = self.modifyExample(example)
                    
                    println(example)
                    
                    self.handleDefinitionView(partOfSpeech, definitions: definitions, synonyms: synonyms, example: example)
                    
                })
            })
        })
    }

    func modifyExample(example: String) -> String {
        
        var newExample = example.stringByReplacingOccurrencesOfString("™", withString: "")
        var newNewExample = newExample.stringByReplacingOccurrencesOfString("˜", withString: "")
        var newNewNewExample = newNewExample.stringByReplacingOccurrencesOfString("*", withString: "")
        
        return newNewNewExample
    }
    
    func handleDefinitionView(partOfSpeech:[String], definitions:[String], synonyms:[String], example: String) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in

            var numberOfDefinitions = partOfSpeech.count
            
            println(numberOfDefinitions)
            
            self.firstPartOfSpeech?.text = partOfSpeech[0]
            self.firstDefinition?.text = definitions[0]
        
            switch numberOfDefinitions{
                
            case 1:
                
                self.topConstraintOfSecondPartOfSpeech.constant = -105
                
                self.secondPartOfSpeech.hidden = true
                self.secondDefinition.hidden = true
                self.thirdDefinition.hidden = true
                self.thirdPartOfSeech.hidden = true
                
            case 2:
                
                self.topConstraintOfThirdPartOfSpeech.constant = -45
                
                self.thirdDefinition.hidden = true
                self.thirdPartOfSeech.hidden = true
                self.secondPartOfSpeech?.text = partOfSpeech[1]
                self.secondDefinition?.text = definitions[1]
                
            default:
                
                self.secondPartOfSpeech?.text = partOfSpeech[1]
                self.secondDefinition?.text = definitions[1]
                self.thirdPartOfSeech?.text = partOfSpeech[2]
                self.thirdDefinition?.text = definitions[2]

            }
            
            if synonyms == [] {
                
                self.synonymsLabel.hidden = true
                self.synonymsTitleLabel.hidden = true
                self.topConstraintOfExample.constant = -45
                
            } else {
                
                var synonymsString: String = ", ".join(synonyms)
                self.synonymsLabel.text = synonymsString
            }
            
            self.exampleLabel.text = example
            
            self.definitionView.hidden = false
            
            println("definition view handled")
            
        })

    }
    
    
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

// MARK: Table View

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
        
        let wordSelected = searchResult![indexPath.row]
        
        searchBar.text = wordSelected
        
        getDefinition(wordSelected)
        
        searchBar.resignFirstResponder()
        
        resultTableView.hidden = true
    }
    
}
    
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(searchBar: UITextField) -> Bool{
        
        searchBar.resignFirstResponder()
        return true
        
    }
}








