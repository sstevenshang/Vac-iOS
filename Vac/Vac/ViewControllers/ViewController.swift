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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        resultTableView.hidden = true
        
        searchBar.attributedPlaceholder = NSAttributedString (string:"Search!", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        searchBar.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // Search
    
    let dictionary = DictionaryHelper()
    var searchResult: [String]?
    
    func textFieldDidChange(searchBar: UITextField) {
        
        if !searchBar.text.isEmpty{
            
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
    
    // Guillotine Menu
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showMenu") {
            
            let destinationVC = segue.destinationViewController as! GuillotineMenuViewController
            destinationVC.hostNavigationBarHeight = self.navigationController!.navigationBar.frame.size.height
            destinationVC.view.backgroundColor = self.navigationController!.navigationBar.barTintColor
            destinationVC.setMenuButtonWithImage(menuButton.imageView!.image!)
            
        }
    }
}

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

