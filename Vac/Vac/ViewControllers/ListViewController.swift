//
//  ListViewController.swift
//  Vac
//
//  Created by Steven Shang on 8/11/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!

    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var searchBar: UITextField!
    
    var data: Word?
    var words = [Word]()
    var wordsShown = [Word]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("I got here, dad.")
        let realm = Realm()
        let savedWords = realm.objects(Word)
        
        for savedWord in savedWords {
            
            if !contains(words, savedWord){
                words.append(savedWord)
            }
        }
        
        showAll()
        
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 15.0
        searchBar.attributedPlaceholder = NSAttributedString (string:"Search!", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        let clearButton = UIButton(frame: CGRectMake(0, 0, 15, 15))
        clearButton.setImage(UIImage(named: "ClearButton")!, forState: UIControlState.Normal)
        searchBar.rightView = clearButton
        clearButton.addTarget(self, action: "clear:", forControlEvents: UIControlEvents.TouchUpInside)
        searchBar.rightViewMode = UITextFieldViewMode.WhileEditing
        searchBar.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clear(clearButton: UIButton) {
        
        searchBar.text = ""
        showAll()
        listTableView.reloadData()
    }
    
    
    func constructDefinition(aWord: Word) -> String {
        
        var aString = String()
        
        var partOfSpeechArray = [String]()
        
        for partOfSpeech in aWord.partOfSpeech{
            
            let part = partOfSpeech.thisString
            if !contains(partOfSpeechArray, part){
                partOfSpeechArray.append(part)
            }
        }
        
        aString = "/".join(partOfSpeechArray)
        
        if aWord.synonyms != "" {
            aString += ": \(aWord.synonyms)"
        } else{
            aString += ": \(aWord.definitions[0].thisString)"
        }
        
        return aString
    }
    
    // MARK: SearchBar
    
    func textFieldDidChange(searchBar: UITextField) {
        
        if !searchBar.text.isEmpty {
            
            wordsShown.removeAll(keepCapacity: false)
            findWords(searchBar.text)
            listTableView.reloadData()
            println(wordsShown.count)
            
        } else {
            
            println("I'M HERE!")
            showAll()
            listTableView.reloadData()
        }
    }
    
    func showAll() {
        
        for word in words {
            wordsShown.append(word)
        }
    }
    
    func findWords(aString: String) {
        
        for word in words {
            
            if word.word.lowercaseString.rangeOfString(aString) != nil {
                wordsShown.append(word)
            }
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
        
        if (segue.identifier == "showListWord") {
            
            println("hi, dad.")
            let destination : UINavigationController = segue.destinationViewController as! UINavigationController
            let lwvc : ListWordViewController = destination.viewControllers[0] as! ListWordViewController
            lwvc.word = data!
            
        }
    }
}

// MARK: TableView

extension ListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println(words.count)
        return wordsShown.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListWordCell", forIndexPath: indexPath) as! ListWordCell
        let wordOfCell = wordsShown[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.listWord.text = wordOfCell.word
        cell.listDefinition.text = constructDefinition(wordOfCell)
        println(wordOfCell.word)
        
        return cell
    }
}


// MARK: TextField

extension ListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(searchBar: UITextField) -> Bool{
        
        searchBar.resignFirstResponder()
        return true
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        data = wordsShown[indexPath.row]
        
        performSegueWithIdentifier("showListWord", sender: tableView.cellForRowAtIndexPath(indexPath))

    }
}


/*
// Override to support rearranging the table view.
override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

}
*/

/*
// Override to support conditional rearranging of the table view.
override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
// Return NO if you do not want the item to be re-orderable.
return true
}
*/
