//
//  ContainerViewController.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/9/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var viewControllers = [UIViewController]()

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBarView: UITabBar!


    override func viewDidLoad() {
        super.viewDidLoad()

        displayContentController(viewControllers[0])

        tabBarView.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuSelected:", name: "menuSelected", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func displayContentController(content: UIViewController) {
        addChildViewController(content)
        containerView.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }

    func menuSelected(notification: NSNotification) {
        if notification.name == "menuSelected" {
            var destinationViewController = notification.object as? UIViewController
            if let destinationVC = destinationViewController {
                displayContentController(destinationVC)
            }
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

extension ContainerViewController: UITabBarDelegate {
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        var selectedVC = self.viewControllers[item.tag]
        displayContentController(selectedVC)
    }
}