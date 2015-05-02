//
//  TweetViewController.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/2/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    var tweet: Tweet?

    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tweet = tweet {
            nameLabel.text = tweet.user?.name
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
