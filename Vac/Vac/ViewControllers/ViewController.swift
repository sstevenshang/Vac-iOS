//
//  ViewController.swift
//  Vac
//
//  Created by Steven Shang on 7/20/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet weak var searchBar: UITextField!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.attributedPlaceholder = NSAttributedString (string:"Search", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println(searchBar.center)
        println(menuButton.frame.origin)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let destinationVC = segue.destinationViewController as! GuillotineMenuViewController
        destinationVC.hostNavigationBarHeight = self.navigationController!.navigationBar.frame.size.height
        destinationVC.view.backgroundColor = self.navigationController!.navigationBar.barTintColor
        destinationVC.setMenuButtonWithImage(menuButton.imageView!.image!)
    }
    


}