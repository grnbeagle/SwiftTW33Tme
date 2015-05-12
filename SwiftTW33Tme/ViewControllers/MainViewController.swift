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
    var showingMenu = false

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

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuSelected:", name: "menuSelectedByTag", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hamburgerTapped:", name: "hamburgerTapped", object: nil)
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
            if direction == "R" {
                var x: CGFloat = view.frame.size.width - 150
                slideContainerBy(x)
            } else {
                var x: CGFloat = 0
                slideContainerBy(x)
            }
        default:
            println("\(gestureRecognizer.state)")
        }
    }

    func slideContainerBy(distance: CGFloat) {
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.containerViewController.view.frame = CGRect(x: distance, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: { (finished) -> Void in
                self.showingMenu = distance > 0
        })
    }

    func menuSelected(notification: NSNotification) {
        if notification.name == "menuSelectedByTag" {
            slideContainerBy(0)
            var index = notification.object as? Int
            if let index = index {
                if index < 2 {
                    var viewController = viewControllers![index]
                    containerViewController.displayContentController(viewController)
                } else if index == 2 {
                    User.currentUser?.logout()
                }
            }
        }
    }

    func hamburgerTapped(notification: NSNotification) {
        if notification.name == "hamburgerTapped" {
            toggleMenu()
        }
    }

    func toggleMenu() {
        if showingMenu {
            slideContainerBy(0)
        } else {
            self.view.sendSubviewToBack(menuView)
            var x: CGFloat = view.frame.size.width - 150
            slideContainerBy(x)
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
