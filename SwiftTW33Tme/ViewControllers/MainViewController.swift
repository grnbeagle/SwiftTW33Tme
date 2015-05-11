//
//  MainViewController.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/9/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var containerViewController: ContainerViewController!
    var menuViewController: MenuViewController!
    var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var viewControllers: [UIViewController]?
    var panStartCoordinate: CGPoint?
    var direction = "right"

    var menuView: UIView {
        if menuViewController == nil {
            menuViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
            view.addSubview(menuViewController.view)
            addChildViewController(menuViewController)
            menuViewController.didMoveToParentViewController(self)
            menuViewController.view.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        }
        return menuViewController.view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var homeViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeScreen") as? UIViewController
        var profileViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ProfileViewController") as? UIViewController
        containerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController


        viewControllers = [homeViewController!, profileViewController!]

        containerViewController.viewControllers = viewControllers!
        view.addSubview(containerViewController.view)
        addChildViewController(containerViewController)
        containerViewController.didMoveToParentViewController(self)


        var panGesture = UIPanGestureRecognizer(target: self, action: "onPan:")
        panGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onPan(gestureRecognizer: UIPanGestureRecognizer) {
        var point = gestureRecognizer.locationInView(view)
        switch (gestureRecognizer.state) {
        case .Began:
            panStartCoordinate = point
        case .Changed:
            var distance = point.x - panStartCoordinate!.x
            if (distance > 0) { // drag right
                direction = "R"
                self.view.sendSubviewToBack(menuView)
            } else {
                direction = "L"
                distance =  0
            }
            var movedFrame = containerViewController.view.frame
            movedFrame.origin.x = distance
            containerViewController.view.frame = movedFrame
        case .Ended:
            println("ended")
        default:
            println("\(gestureRecognizer.state)")
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
