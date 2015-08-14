//
//  StudyViewController.swift
//  Vac
//
//  Created by Steven Shang on 8/14/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import RealmSwift

class StudyViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var wordsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = Realm()
        var wordsCount = realm.objects(Word).count
        
        var sentence: String = "You Got \(wordsCount) Words"
        
        wordsCountLabel.text = sentence
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

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
