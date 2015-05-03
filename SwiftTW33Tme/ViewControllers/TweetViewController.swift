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
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!

    @IBOutlet weak var containerTopSpacingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        retweetLabel.textColor = UIColor.tweetmeGrayColor()
        screennameLabel.textColor = UIColor.tweetmeGrayColor()

        if let tweet = tweet {
            if let user = tweet.user {
                nameLabel.text = user.name
                screennameLabel.text = "@\(user.screenName!)"
                var imageURL = NSURL(string: user.profileImageUrl!)
                pictureView.loadAsync(imageURL!, animate: true, failure: nil)
            }
            messageLabel.text = tweet.text!
            if tweet.retweet {
                if let retweetUser = tweet.retweetUser {
                    retweetLabel.text = "\(retweetUser.name!) retweeted"
                }
                retweetLabel.hidden = false
                containerTopSpacingConstraint.constant = 28
            } else {
                retweetLabel.text = ""
                retweetLabel.hidden = true
                containerTopSpacingConstraint.constant = 0
            }
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
