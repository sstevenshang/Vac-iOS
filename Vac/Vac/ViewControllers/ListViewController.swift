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
    
    var words = [Word]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("I got here, dad.")
        let realm = Realm()
        let savedWords = realm.objects(Word)
        
        for savedWord in savedWords {
            
            words.append(savedWord)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}

// MARK: TableView Data Source

extension ListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println(words.count)
        return words.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListWordCell", forIndexPath: indexPath) as! ListWordCell
        let wordOfCell = words[indexPath.row]
        
        cell.listWord.text = wordOfCell.word
        cell.listDefinition.text = constructDefinition(wordOfCell)
        println(wordOfCell.word)
        
        return cell
    }
}


/*
// Override to support conditional editing of the table view.
override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
// Return NO if you do not want the specified item to be editable.
return true
}
*/

/*
// Override to support editing the table view.
override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
if editingStyle == .Delete {
// Delete the row from the data source
tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
} else if editingStyle == .Insert {
// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
}
}
*/

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

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
}
*/
