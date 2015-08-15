//
//  GuillotineViewController.swift
//  GuillotineMenu
//
//  Created by Maksym Lazebnyi on 3/24/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import Mixpanel
import BubbleTransition

class GuillotineMenuViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var hostNavigationBarHeight: CGFloat!

    @IBOutlet weak var aboutButton: UIButton!
    
    var menuButton: UIButton!
    var menuButtonLeadingConstraint: NSLayoutConstraint!
    var menuButtonTopConstraint: NSLayoutConstraint!
    
    private let menuButtonPortraitLeadingConstant: CGFloat = 7
    private let hostNavigationBarHeightPortrait: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition(nil) { (context) -> Void in

                let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
                self.menuButtonLeadingConstraint.constant = self.menuButtonPortraitLeadingConstant
                self.menuButtonTopConstraint.constant = self.menuButtonPortraitLeadingConstant + statusbarHeight
        }
    }
    
    // MARK: Actions
    
    func closeMenuButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("Dismissed menu")
        
    }
    
    func setMenuButtonWithImage(image: UIImage) {
        let statusbarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        let buttonImage = UIImage(CGImage: image.CGImage, scale: 1.0, orientation: .Right)
        
        menuButton = UIButton(frame: CGRectMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant+statusbarHeight, 30.0, 30.0))
        
        menuButton.setImage(image, forState: .Normal)
        menuButton.setImage(image, forState: nil)
        menuButton.imageView!.contentMode = .Center
        menuButton.addTarget(self, action: Selector("closeMenuButtonTapped"), forControlEvents: .TouchUpInside)
        menuButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        menuButton.transform = CGAffineTransformMakeRotation( ( 90 * CGFloat(M_PI) ) / 180 );
        self.view.addSubview(menuButton)
        
        var (leading, top) = self.view.addConstraintsForMenuButton(menuButton, offset: UIOffsetMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant + statusbarHeight))
        
        menuButtonLeadingConstraint = leading
        menuButtonTopConstraint = top
        
    }
    
    // MARK: MyCustomization
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    // MARK: About
    
    let transition = BubbleTransition()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAbout" {
            if let controller = segue.destinationViewController as? UIViewController {
                controller.transitioningDelegate = self
                controller.modalPresentationStyle = .Custom
            }
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = aboutButton.center
        transition.bubbleColor = UIColor(white: 0.14, alpha: 1.0)
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = aboutButton.center
        transition.bubbleColor = UIColor(white: 0.14, alpha: 1.0)
        return transition
    }
    
}

extension GuillotineMenuViewController: GuillotineAnimationProtocol {

    func anchorPoint() -> CGPoint {
        
        return self.menuButton.center
    }
    
    func navigationBarHeight() -> CGFloat {
        
        return hostNavigationBarHeightPortrait
    }
    
}

