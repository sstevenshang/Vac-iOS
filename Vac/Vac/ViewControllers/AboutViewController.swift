//
//  AboutViewController.swift
//  Vac
//
//  Created by Steven Shang on 8/14/15.
//  Copyright (c) 2015 Steven Shang. All rights reserved.
//

import UIKit
import BubbleTransition
import Mixpanel

class AboutViewController: UIViewController {

    @IBOutlet weak var goBackButton: UIButton!
    
    @IBAction func goBackButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBOutlet weak var aboutText: UITextView!
    
    let about: String = "Hi, folks. This app is a personal project by Steven(me). The current version you are using is an early beta version. Many more features and refinements are still under developmet." +
        "\n\nThe dictionary is powered by Wordnik API, which as you might have noticed is not highly reliable. Some of the examples and definitions curated are inadequate or nonsensical. I've been looking for alternative APIs, and I promise a better, more accurate dictionary is on its way." +
        "\n\nThank you for downloading the app. Please leave any comment or suggestion on App Store. Your reviews wll help me greatly in improving this app!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("About page launched")
        
        aboutText.text = about
        aboutText.textColor = UIColor.whiteColor()
        aboutText.font = UIFont(name: "HelveticaNeue-Light", size: 17)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    


}
