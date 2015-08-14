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
    
    // MARK: Front
    
    
    
    
    // MARK: BACK
    
    
    
    
    
    
    
    
    
    
    
    
    
    var layer: CALayer {
        return mainView.layer
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.grayColor().CGColor
        layer.shadowColor = UIColor.whiteColor().CGColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        var touch = UITapGestureRecognizer(target:self, action:"tapped")
        mainView.addGestureRecognizer(touch)
        
        showingFront = true
    }
    
    var showingFront: Bool = true

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapped() {
        println("hayyyy")
        
        if showingFront {
            UIView.transitionFromView(frontView, toView: backView, duration: 0.5, options: .TransitionFlipFromLeft | .ShowHideTransitionViews , completion: nil)
            showingFront = false
        } else {
            UIView.transitionFromView(backView, toView: frontView, duration: 0.5, options: .TransitionFlipFromRight | .ShowHideTransitionViews , completion: nil)
            showingFront = true
        }

    }

}
