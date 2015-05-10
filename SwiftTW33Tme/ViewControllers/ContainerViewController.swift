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

        //navigationController!.setViewControllers([viewControllers[0]], animated: false)
        displayContentController(viewControllers[0])

//        var homeButton = UITabBarItem(title: "Timeline", image: UIImage(named:"Timeline"), tag: 0)
//        var profileButton = UITabBarItem(title: "Profile", image: UIImage(named:"Profile"), tag: 1)
//        tabBarView.setItems([homeButton, profileButton], animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
